-- DEC-022 permits revising fixture terms during MVP development.
drop trigger immutable_program_version on loyalty.program_versions;
drop function loyalty.protect_program_version();
