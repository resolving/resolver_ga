require_relative 'ncile'
require 'ostruct'

national = Company.where(local: false)

ids = national.collect do |n|
  n.services.pluck(:id)
end.flatten

service_types = ServiceType.all.collect do |st|

  counts = st.services.where(id: ids).collect do |s|
    s.case_files.count
  end.sort

  median = Ncile.new(counts, nil).median
  quartile = median / 2 

  underperformers = st.services.where(id: ids).select do |s|
    s.case_files.count >= quartile && s.case_files.count <= median * 0.75
  end

  OpenStruct.new(
    name: st.name,
    counts: counts,
    median: median,
    under_performers: underperformers
  )
end

service_types.sort!{|a,b| a.median * a.counts.length <=> b.median * b.counts.length }

File.open("/tmp/opportunities.txt","w") do |file|
  service_types.reverse.each do |ostruct|
    file.puts
    file.puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    file.puts "#{ostruct.name.upcase} services: #{ostruct.counts.length} median: #{ostruct.median}"
    file.puts "------------------------------------------"
    if ostruct.under_performers.empty?
      file.puts "[NO UNDERPERFORMERS]"
    else
      ostruct.under_performers.each do |underperformer|
        file.puts "#{underperformer.company.name} - #{underperformer.name} - #{underperformer.case_files.count}"
      end
    end
    file.puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    file.puts
  end
end
