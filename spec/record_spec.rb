require File.join(File.dirname(__FILE__), 'spec_helper')

describe DNSimple::Record do
  before do
    #DNSimple::Client.debug = true 
    DNSimple::Client.credentials('anthonyeden@gmail.com', 'letmein')
  end

  describe "a new record" do
    before do
      @domain = DNSimple::Domain.create("testdomain.com")
      @record = DNSimple::Record.create("testdomain.com", "", "A", "1.2.3.4", :ttl => 600)
    end
    after do
      #@record.delete
      @domain.delete
    end
    it "has specific attributes" do 
      @record.name.should eql("")
      @record.record_type.should eql("A")
      @record.content.should eql("1.2.3.4")
      @record.ttl.should eql(600)
      @record.id.should_not be_nil
    end
    it "can be found by id" do
      record = DNSimple::Record.find(@domain.name, @record.id)
      record.name.should eql("")
      record.record_type.should eql("A")
      record.content.should eql("1.2.3.4")
      record.ttl.should eql(600)
      record.id.should_not be_nil
    end
  end

  describe ".all" do
    before do
      @domain = DNSimple::Domain.create("testdomain.com")
      @records = []
      
      @records << DNSimple::Record.create("testdomain.com", "", "A", "4.5.6.7")
      @records << DNSimple::Record.create("testdomain.com", "www", "CNAME", "testdomain.com")
      @records << DNSimple::Record.create("testdomain.com", "", "MX", "mail.foo.com", :prio => 10)
    end
    after do
      @domain.destroy
    end
    it "returns a list of records" do
      records = DNSimple::Record.all(@domain.name)
      records.should_not be_empty
      records.length.should eql(@records.length)
    end
  end
end

