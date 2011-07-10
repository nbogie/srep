class AddResultsToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :results, :text
    add_column :reports, :executed_at, :timestamp
    add_column :reports, :time_taken, :integer
  end

  def self.down
    remove_column :reports, :results
  end
end
