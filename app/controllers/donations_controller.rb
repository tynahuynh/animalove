class DonationsController < ApplicationController
	before_action :authenticate_user!
	before_action :require_documents

	def new	
	end

	def create
		#banking login information from user
		login_info = {
				bank_name:                params[:donation][:bank_name],
		  		username:                 params[:donation][:username],
		  		password:                 params[:donation][:password]
		}

		@user = SynapsePayRest::User.find(client: $client, id: current_user.synapse_id )
		@nodes = @user.create_ach_us_nodes_via_bank_login(login_info)


		#to help with MFA verification -- may implement user input later
		if !@nodes.kind_of?(Array) && @nodes.mfa_verified == false
			@nodes = @nodes.answer_mfa('test_answer')
		end



		node = @nodes.first

		#actual transaction call
		transaction_settings = {
			to_type:  'ACH-US',
			to_id:    ENV['CLIENT_NODE'],
			amount:   params[:donation][:donation_amount].to_f,
			currency: 'USD',
			ip:       '127.0.0.1'
		}

		transaction = node.create_transaction(transaction_settings)

		#to account for errors from API calls
		rescue SynapsePayRest::Error => e
	    flash[:error] = e.message
	    redirect_to donations_path

	end

	private

	#requires documents to be verified first
	def require_documents
		@user = SynapsePayRest::User.find(client: $client, id: current_user.synapse_id )
    	unless @user.permission == "SEND-AND-RECEIVE"
	      	flash[:error] = "Please verify yourself"
	      	redirect_to documents_path
	    end
    end
end
