require 'sequel'
require 'fastercsv'

class Report < ActiveRecord::Base

  def execute
    logger.info(self.inspect)
    db = Sequel.connect(Reportapp::REPORTDB_CONN_STR)
    sql = self.query
    logger.info "query is #{sql}"

    raise "No query! #{sql}" if sql.blank?

    d = db.fetch(sql)

    if d.first.nil?
      out = ""
    else
      fields = d.first.keys
      csv = FasterCSV.generate do |csv|
        csv << fields #add headers line
        d.all.each do |record|
          csv << fields.map {|f| record[f] }
        end
      end
      out = csv
    end

    out
  end

end
