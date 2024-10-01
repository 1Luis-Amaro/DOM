Declare
--
Cursor C1 is
   select fcp.concurrent_program_name
         ,fcp.concurrent_program_id
         ,fa.application_short_name
     from apps.fnd_concurrent_programs fcp
         ,apps.fnd_application         fa
    where fa.application_id = fcp.application_id
      and fcp.concurrent_program_name like '%VALORIZA%ESTOQU%';
R1 C1%rowtype;
--
Begin
   --
   Open C1;
      --
      Loop
         --
         Fetch C1 into R1;
         Exit When C1%notfound;
         --
         fnd_program.delete_program(R1.concurrent_program_name, R1.application_short_name);
         fnd_program.delete_executable(R1.concurrent_program_name, R1.application_short_name);
         --
         commit;
         --
      End Loop;
      --
   Close C1;
   --
End;

