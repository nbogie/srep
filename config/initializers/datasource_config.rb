module Reportapp
  file = File.join(Rails.root, "config", "source_database.yml")
  begin
    conf = YAML.load(IO.read(file))[Rails.env]
    raise "nil conf" if conf.nil?
    REPORTDB_CONN_STR = conf
  rescue => e
    raise e, "Failure configuring source database: #{e.message}.  Have you specified your environment \"#{Rails.env}\" in #{file}?"
  end
end

