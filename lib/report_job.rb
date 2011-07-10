class ReportJob < Struct.new(:report_id)

  require 'benchmark'

  def perform
    rep = Report.find(report_id)
    xlog "Executing report: #{rep.id}: #{rep.title}"
    csv=nil
    duration = Benchmark.realtime {
      csv = rep.execute
    }
    raise "execute returned nil!" if csv.nil?
    rep.results = csv
    rep.executed_at = Time.now #do we want start or end time?
    rep.time_taken = duration
    rep.save!
    xlog "Results of report #{rep.id}: #{csv}"
  end

  #def before(job)
  #end
  #def after(job)
  #end

  def success(job)
    xlog "success: #{job.inspect}"
  end

  def error(job, exception)
    xlog "#{job} #{exception.inspect}"
  #  notify_hoptoad(exception)
  end

  def failure
    xlog "failure"
  end

  def xlog(msg)
    Rails.logger.info "XYZZY: #{msg}"
  end

end
