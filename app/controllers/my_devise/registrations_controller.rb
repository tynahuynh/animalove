class MyDevise::RegistrationsController < Devise::RegistrationsController
  def create
   	super
   	#once a new person has signed up on devise, they will be created in SynapseFI
   	if resource.save
    	user_create_settings = {
		  client:        $client,
		  logins:        [{email: current_user.email}],
		  phone_numbers: [current_user.phone_number],
		  legal_names:   [current_user.legal_name]
		}

		user = SynapsePayRest::User.create(user_create_settings)

		resource.update_attribute(:synapse_id, user.id)

	end
	

  end

end
