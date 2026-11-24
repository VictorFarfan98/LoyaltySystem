revoke select (business_id, id, name) on public.branches from authenticated;
drop policy read_assigned_active_branches on public.branches;
drop function loyalty.visible_branches();

-- Moving the existing table keeps branch IDs, foreign keys and RLS intact.
alter table public.branches set schema loyalty;

create function public.list_my_branches() returns table (business_id bigint, id bigint, name text)
language sql stable security definer set search_path = '' as $$
  select b.business_id, b.id, b.name
  from loyalty.staff_memberships m
  join loyalty.businesses t on t.id = m.business_id and t.status = 'active'
  join loyalty.branches b on b.business_id = m.business_id and b.active
  where m.user_id = (select auth.uid()) and m.active
    and m.role in ('owner', 'manager', 'branch_staff')
    and (m.all_branches or exists (
      select 1 from loyalty.staff_branches s
      where (s.business_id, s.user_id, s.branch_id) = (m.business_id, m.user_id, b.id)
    ))
$$;
alter function public.list_my_branches() owner to postgres;
revoke all on function public.list_my_branches() from public, anon, authenticated, service_role;
grant execute on function public.list_my_branches() to authenticated;
