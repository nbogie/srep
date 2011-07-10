Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_attempts = 1
#Delayed::Worker.sleep_delay = 60 #how long to sleep when no jobs found
Delayed::Worker.max_run_time = 5.minutes
#Delayed::Worker.delay_jobs = !Rails.env.test?
#
#?? undocumented
#Delayed::Worker.logger = Rails.logger
