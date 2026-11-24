begin;
create extension if not exists pgtap with schema extensions;
set local search_path = public, extensions;
select plan(44);

insert into loyalty.businesses (id, name) values (1, 'Fixture A'), (2, 'Fixture B');
-- Reuse branch 11 in both tenants to exercise the tenant boundary.
insert into loyalty.branches (business_id, id, name, active) values
  (1, 11, 'A North', true), (1, 12, 'A East', true), (1, 13, 'A West', true),
  (1, 14, 'A Closed', false), (2, 11, 'B Central', true);
insert into auth.users (id)
select ('00000000-0000-4000-8000-' || lpad(n::text, 12, '0'))::uuid
from generate_series(1, 9) n;
insert into loyalty.staff_memberships (user_id, business_id, role, active, all_branches) values
  ('00000000-0000-4000-8000-000000000001', 1, 'owner', true, true),
  ('00000000-0000-4000-8000-000000000002', 1, 'manager', true, false),
  ('00000000-0000-4000-8000-000000000003', 1, 'branch_staff', true, false),
  ('00000000-0000-4000-8000-000000000004', 1, 'marketing', true, false),
  ('00000000-0000-4000-8000-000000000005', 1, 'manager', false, true),
  ('00000000-0000-4000-8000-000000000006', 1, 'manager', true, false),
  ('00000000-0000-4000-8000-000000000007', 2, 'manager', true, true),
  ('00000000-0000-4000-8000-000000000008', 2, 'branch_staff', true, false);
insert into loyalty.staff_branches (business_id, user_id, branch_id) values
  (1, '00000000-0000-4000-8000-000000000002', 12),
  (1, '00000000-0000-4000-8000-000000000003', 11),
  (1, '00000000-0000-4000-8000-000000000003', 13),
  (1, '00000000-0000-4000-8000-000000000003', 14);

insert into loyalty.programs (business_id, id, status) values
  (1, 101, 'active'), (1, 102, 'draft'), (2, 201, 'active');
insert into loyalty.program_versions (business_id, program_id, version, stamp_goal, reward_description)
values (1, 101, 1, 5, 'Fixture reward'), (1, 101, 2, 8, 'Revised fixture reward');
insert into loyalty.customers (business_id, id, program_id, display_name, normalized_phone)
values (1, 1, 101, 'Fixture One', '+12025550101'),
       (1, 2, 101, 'Fixture Two', '+12025550101'), (2, 3, 201, 'Fixture Three', '+12025550103');
insert into loyalty.pass_credentials (id, business_id, customer_id, program_id, token_hash)
values (1, 1, 1, 101, sha256(convert_to('fixture-token-a', 'UTF8')));

select throws_ok($$insert into loyalty.staff_branches values
  (2, '00000000-0000-4000-8000-000000000008', 12)$$,
  '23503', null, 'An assignment cannot reference another business branch');
select throws_ok($$insert into loyalty.staff_branches values
  (2, '00000000-0000-4000-8000-000000000003', 11)$$,
  '23503', null, 'An assignment cannot reference another business membership');
select throws_ok($$insert into loyalty.staff_memberships (user_id, business_id, role) values
  ('00000000-0000-4000-8000-000000000003', 2, 'manager')$$,
  '23505', null, 'A staff identity can belong to only one business');
select throws_ok($$insert into loyalty.staff_memberships (user_id, business_id, role) values
  ('00000000-0000-4000-8000-000000000009', 1, null)$$,
  '23502', null, 'Membership requires a role');
select throws_ok($$update loyalty.staff_memberships set all_branches = true where role = 'branch_staff'$$,
  '23514', null, 'Branch staff cannot receive an all-branch grant');
select throws_ok($$update loyalty.programs set status = 'active' where id = 102$$,
  '23505', null, 'Activating a second program fails');
select throws_ok($$insert into loyalty.program_versions values (1, 201, 1, 4, 'Fixture', null)$$,
  '23503', null, 'A version cannot reference another business program');
select throws_ok($$update loyalty.customers set program_id = 201 where business_id = 1$$,
  '23503', null, 'A customer cannot enroll in another business program');
select throws_ok($$update loyalty.pass_credentials set customer_id = 3 where id = 1$$,
  '23503', null, 'A pass cannot reference another business customer');
select throws_ok($$update loyalty.pass_credentials set program_id = 201 where id = 1$$,
  '23503', null, 'A pass cannot reference another business program');
select throws_ok($$update loyalty.pass_credentials set program_id = 102 where id = 1$$,
  '23503', null, 'A pass must match the customer enrollment even within one business');
select throws_ok($$update loyalty.pass_credentials set token_hash = convert_to('fixture-token-a', 'UTF8')$$,
  '23514', null, 'Pass credentials require a 32-byte digest');
select throws_ok($$update loyalty.pass_credentials set status = 'rotated' where id = 1$$,
  '23514', null, 'Ending a pass requires its lifecycle timestamp');

update loyalty.program_versions set stamp_goal = 9
where business_id = 1 and program_id = 101 and version = 1;
select is((select stamp_goal from loyalty.program_versions
  where business_id = 1 and program_id = 101 and version = 1), 9,
  'Developers can revise an existing fixture version in place (DEC-022)');
select is((select count(*) from loyalty.customers where business_id = 1 and normalized_phone = '+12025550101'),
  2::bigint, 'Two customers can share a normalized phone');
select is((select marketing_consent from loyalty.customers where id = 1), false, 'Marketing defaults off');
update loyalty.customers set marketing_consent = true where id = 1;
update loyalty.customers set marketing_consent = false where id = 1;
select is((select array_agg(granted order by id) from loyalty.marketing_consent_changes
  where business_id = 1 and customer_id = 1 and changed_at between transaction_timestamp() and clock_timestamp()),
  array[true, false], 'Opt-in and withdrawal retain both decisions and server times');
update loyalty.customers set active = false where id = 1;
select is((select count(*) from loyalty.pass_credentials p join loyalty.customers c
  on (c.business_id, c.id) = (p.business_id, p.customer_id) where not c.active),
  1::bigint, 'Customer deactivation preserves the pass reference');

select ok(not exists (select from pg_class c join pg_namespace n on n.oid = c.relnamespace
  where n.nspname = 'loyalty'
    and c.relkind = 'r' and not c.relrowsecurity), 'Every foundation table enables RLS');
select ok((select prosecdef and pg_get_userbyid(proowner) = 'postgres'
    and proconfig = array['search_path=""']
  from pg_proc where oid = 'public.list_my_branches()'::regprocedure)
  and not has_function_privilege('anon', 'public.list_my_branches()', 'EXECUTE')
  and has_function_privilege('authenticated', 'public.list_my_branches()', 'EXECUTE')
  and not has_schema_privilege('authenticated', 'loyalty', 'USAGE'),
  'Branch RPC uses a trusted owner and empty search path, with private tables and authenticated execution');

-- The SQL roles and JWT subject here are the context the API sets after verification.
set local role authenticated;
set local request.jwt.claims = '{"sub":"00000000-0000-4000-8000-000000000001"}';
select results_eq('select business_id, id, name from public.list_my_branches() order by id',
  $$values (1::bigint, 11::bigint, 'A North'::text), (1, 12, 'A East'), (1, 13, 'A West')$$,
  'Owner receives branch identifiers and names only in the active tenant and branch scope');
select throws_ok('select name from loyalty.branches', '42501', null,
  'Even an owner cannot read the branch table directly');
select throws_ok('select token_hash from loyalty.pass_credentials', '42501', null,
  'Even an owner cannot read credential hashes directly');
select throws_ok('update loyalty.branches set business_id = 2 where id = 11', '42501', null,
  'Direct tenant reassignment is forbidden');
set local request.jwt.claims = '{"sub":"00000000-0000-4000-8000-000000000002"}';
select is(array(select name from public.list_my_branches()), array['A East'], 'Scoped manager sees only the assigned branch');
set local request.jwt.claims = '{"sub":"00000000-0000-4000-8000-000000000003"}';
select is(array(select name from public.list_my_branches() order by id), array['A North','A West'],
  'Staff see all and only their active assigned branches');
select throws_ok($$update loyalty.staff_memberships set role = 'owner', all_branches = true
  where user_id = auth.uid()$$, '42501', null, 'Staff cannot promote themselves');
select throws_ok($$insert into loyalty.staff_branches values (1, auth.uid(), 12)$$,
  '42501', null, 'Staff cannot expand their branch assignment');
set local request.jwt.claims = '{"sub":"00000000-0000-4000-8000-000000000004","pass_token":"fixture-token-a"}';
select is((select count(id) from public.list_my_branches()), 0::bigint, 'Marketing has no operational branches');
select throws_ok('select display_name, normalized_phone from loyalty.customers', '42501', null,
  'Marketing cannot read operational customer or contact data');
select throws_ok($$select customer_id from loyalty.pass_credentials
  where token_hash = sha256(convert_to('fixture-token-a', 'UTF8'))$$, '42501', null,
  'Marketing cannot use a valid token to access its pass');
select throws_ok('update loyalty.customers set marketing_consent = true', '42501', null,
  'Marketing cannot mutate operational records');
set local request.jwt.claims = '{"sub":"00000000-0000-4000-8000-000000000005"}';
select is((select count(id) from public.list_my_branches()), 0::bigint, 'Suspended membership loses all-branch access');
set local request.jwt.claims = '{"sub":"00000000-0000-4000-8000-000000000006"}';
select is((select count(id) from public.list_my_branches()), 0::bigint, 'Manager without explicit scope gets no branches');
set local request.jwt.claims = '{"sub":"00000000-0000-4000-8000-000000000007"}';
select is(array(select name from public.list_my_branches()), array['B Central'], 'Explicit all-branch manager stays in business B');
set local request.jwt.claims = '{"sub":"00000000-0000-4000-8000-000000000008"}';
select is((select count(id) from public.list_my_branches()), 0::bigint, 'Unassigned branch staff get no branches');
set local request.jwt.claims = '{"sub":"00000000-0000-4000-8000-000000000009","user_metadata":{"role":"owner"}}';
select is((select count(id) from public.list_my_branches()), 0::bigint, 'An Auth identity without membership has no role');
set local role anon;
set local request.jwt.claims = '{"pass_token":"fixture-token-a"}';
select throws_ok('select name from public.list_my_branches()', '42501', null, 'Anonymous callers cannot list branches');
select throws_ok($$select customer_id from loyalty.pass_credentials
  where token_hash = sha256(convert_to('fixture-token-a', 'UTF8'))$$, '42501', null,
  'Possession of an issued token gives anonymous callers no access');
select throws_ok($$insert into loyalty.branches (business_id, name) values (1, 'Untrusted')$$, '42501', null,
  'Anonymous callers cannot create branches');

reset role;
update loyalty.branches set active = false where business_id = 1 and id = 11;
set local role authenticated;
set local request.jwt.claims = '{"sub":"00000000-0000-4000-8000-000000000003"}';
select is(array(select name from public.list_my_branches()), array['A West'], 'Deactivation removes an existing branch grant immediately');
reset role;
update loyalty.staff_memberships set active = false where user_id = '00000000-0000-4000-8000-000000000003';
set local role authenticated;
select is((select count(id) from public.list_my_branches()), 0::bigint, 'Staff suspension removes remaining branch access');
reset role;
select is((select count(*) from loyalty.staff_branches where user_id = '00000000-0000-4000-8000-000000000003'),
  3::bigint, 'Branch and staff deactivation preserve assignment references');
update loyalty.businesses set status = 'closed' where id = 2;
set local role authenticated;
set local request.jwt.claims = '{"sub":"00000000-0000-4000-8000-000000000007"}';
select is((select count(id) from public.list_my_branches()), 0::bigint, 'Closed business blocks an otherwise active manager');
reset role;

select * from finish();
rollback;
