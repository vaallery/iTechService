# frozen_string_literal: true

class RepeatedRepair2Report < BaseReport
  def call
    sql = <<-SQL
      select s1.*, s2.c c1, s3.c c2
      from service_jobs s1
      left join (
          SELECT serial_number, count(*) c FROM service_jobs
          where serial_number is not null and serial_number <> '' and serial_number <> '-'
          GROUP BY serial_number HAVING count(*) > 1
          ) s2 on s1.serial_number = s2.serial_number
      left join (
          SELECT imei, count(*) c FROM service_jobs
          where imei is not null and imei <> '' and imei <> '-'
          GROUP BY imei HAVING count(*) > 1
      ) s3 on s1.imei = s3.imei
      where ((s1.serial_number is not null and s1.serial_number <> '' and s1.serial_number <> '?') or (s1.imei is not null and s1.imei <> '' and s1.imei <> '?'))
        and ( s2.c > 1 or s3.c > 1) and created_at >= '#{Date.parse(start_date).iso8601}' and created_at <= '#{Date.parse(end_date).iso8601}'
        #{"'location_id = ' #{department.id}" if department}
      order by s1.imei, s1.serial_number;
    SQL
    result[:jobs] = ServiceJob.find_by_sql sql
    result
  end
end
