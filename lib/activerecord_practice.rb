require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.
  
  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    Customer.where(first: 'Candice')
  end

  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    Customer.where('email LIKE ?', '%@%').all
  end

  def self.with_dot_org_email
    Customer.where('email LIKE ?', '%.org%').all
  end

  def self.with_invalid_email
    Customer.where('email not LIKE ? AND email != ? AND email IS NOT NULL','%@%', '').all
  end

  def self.with_blank_email
    Customer.where("email is null")
  end

  def self.born_before_1980
    Customer.where('birthdate < ?', '1980-01-01')
  end

  def self.with_valid_email_and_born_before_1980
    Customer.where('email Like ? AND birthdate < ?', '%@%', '1980-01-01')
  end

  def self.last_names_starting_with_b
    Customer.where('last LIKE ?', 'B%').order(:birthdate)
  end

  def self.twenty_youngest
    Customer.order(birthdate: :desc).limit(20)
  end

  def self.update_gussie_murray_birthdate
    Customer.find_by('first = ? AND last = ?', 'Gussie', 'Murray').update(birthdate: Time.parse("2004-02-08"))
  end

  def self.change_all_invalid_emails_to_blank
    Customer.where("email != '' AND email IS NOT NULL and email NOT LIKE '%@%'").update_all(email: '')
  end

  def self.delete_meggie_herman
    Customer.find_by('first = ? AND last = ?', 'Meggie', 'Herman').destroy
  end

  def self.delete_everyone_born_before_1978
    Customer.where('birthdate < ?', Time.parse("1 January 1978")).delete_all
  end

end
