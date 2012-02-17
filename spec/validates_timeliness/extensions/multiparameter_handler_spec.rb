require 'spec_helper'

describe ValidatesTimeliness::Extensions::MultiparameterHandler do

  context "time column" do
    it 'should return string value for invalid date portion' do
      employee = record_with_multiparameter_attribute(:birth_datetime, [2000, 2, 31, 12, 0, 0])
      employee.birth_datetime_before_type_cast.should == '2000-02-31 12:00:00'
    end
     
    it 'should return Time value for valid datetimes' do
      employee = record_with_multiparameter_attribute(:birth_datetime, [2000, 2, 28, 12, 0, 0])
      employee.birth_datetime_before_type_cast.should be_kind_of(Time)
    end
  end

  context "date column" do
    it 'should return string value for invalid date' do
      employee = record_with_multiparameter_attribute(:birth_date, [2000, 2, 31])
      employee.birth_date_before_type_cast.should == '2000-02-31'
    end

    it 'should return Date value for valid date' do
      employee = record_with_multiparameter_attribute(:birth_date, [2000, 2, 28])
      employee.birth_date_before_type_cast.should be_kind_of(Date)
    end

    context "config require_all_fields" do
      it 'should not return a date for incomplete values' do
        ValidatesTimeliness.require_all_date_fields = true
        multiparameter_attribute(:birth_date, [2000])
        employee.birth_date_before_type_cast.should be_nil
      end

      it 'should not return a date value for an incomplete date if the require' do
        ValidatesTimeliness.require_all_date_fields = true
        multiparameter_attribute(:birth_date, [2000,0,0])
        employee.birth_date_before_type_cast.should be_nil
      end

      it 'should require a Date value for an incomplete date' do
        ValidatesTimeliness.require_all_date_fields = false
        multiparameter_attribute(:birth_date, [2000])
        employee.birth_date_before_type_cast.should be_kind_of(Date)
      end
    end
  end

  def record_with_multiparameter_attribute(name, values)
    hash = {}
    values.each_with_index {|value, index| hash["#{name}(#{index+1}i)"] = value.to_s }
    Employee.new(hash)
  end
end
