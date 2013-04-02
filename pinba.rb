#!/usr/bin/env ruby
require 'rubygems'
require 'mysql'

begin
  con = Mysql.new('localhost', 'root', '', 'pinba')
  if ARGV[0] == 'config' then
    puts "graph_title PINBA timers"
    puts "graph_vlabel seconds"
    puts "graph_category application"
    puts "graph_info PINBA timers defined in the application"
    puts "graph_args --base 1000 -l 0"
    con.query("SELECT group_value, operation_value, timer_value, timer_value/req_count AS avg_timer_value, hit_count/req_count AS avg_op_count, timer_value/hit_count AS avg_op_value, hit_count, req_count FROM tag_info_group_operation").each do |row|
      puts "#{row[0]}_#{row[1]}.label #{row[0]}.#{row[1]}"
      puts "#{row[0]}_#{row[1]}.info #{row[0]}.#{row[1]}"
    end
  else
    con.query("SELECT group_value, operation_value, timer_value, timer_value/req_count AS avg_timer_value, hit_count/req_count AS avg_op_count, timer_value/hit_count AS avg_op_value, hit_count, req_count FROM tag_info_group_operation").each do |row|
      puts "#{row[0]}_#{row[1]}.value #{row[3]}"
    end
  end
rescue Mysql::Error => e
  puts "Error code: #{e.errno}"
  puts "Error message: #{e.error}"
  puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
ensure
  con.close if con
end
