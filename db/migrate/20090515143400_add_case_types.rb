class AddCaseTypes < ActiveRecord::Migration
  def self.up
    c1 = CaseType.new
    c1.case_type = "Lagafrumvörp"
    c1.save

    c2 = CaseType.new
    c2.case_type = "Þingsályktunatillögur"
    c2.save
    
    Case.find(:all).each do |c|
      c.case_type = c1
      c.save
    end
  end

  def self.down
  end
end
