class LoadYahooContacts
  
  attr_accessor :id
  
  def initialize(id,consumer,params)
    @id = id
    @consumer = consumer
    @params = params
  end

  def perform
    Government.current = Government.all.last
    @user = User.find(@id)
    offset = 0
    if not @user.is_importing_contacts? or not @user.attribute_present?("imported_contacts_count") or @user.imported_contacts_count > 0
      @user.is_importing_contacts = true
      @user.imported_contacts_count = 0
      @user.save(:validate => false)
    end
    consumer = Contacts::Yahoo.deserialize(@consumer)
    Rails.logger.info "Deserialized yahoo consumer #{consumer.inspect} #{@params}"
    #consumer.authentication_url
#    Rails.logger.info "Deserialized yahoo consumer #{consumer.inspect}"
    if consumer.authorize(@params)
      @contacts = consumer.contacts
    else
      raise "Yahoo contacts import not authorized"
    end
    Rails.logger.info "Yahoo consumer contacts #{consumer.contacts}"
    if @contacts
      @contacts.each do |c|
        Rails.logger.info "Processing contact #{c.inspect}"
#        begin
          if c.email
            contact = UserContact.find_by_email(c.email)
            contact = UserContact.new unless contact
            contact.name = c.name
            contact.email = c.email
            contact.other_user = User.find_by_email(contact.email)
            if @user.followings_count > 0 and contact.other_user
              contact.following = followings.find_by_other_user_id(contact.other_user_id)
            end
            contact.save(:validate => false)          
            offset += 1
            @user.update_attribute(:imported_contacts_count,offset) if offset % 20 == 0        
          end
 #       rescue
  #        next
  #      end
      end
    end
    @user.calculate_contacts_count
    @user.imported_contacts_count = offset
    @user.is_importing_contacts = false
    @user.save(:validate => false)
  end
  
end

