class ReportJob < Struct.new(:report_id)

  def perform
    rep = Report.find(report_id)
    xlog "Executing report: #{rep.id}: #{rep.title}"
    csv = rep.execute
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
