class DocumentsController < ApplicationController
	before_action :authenticate_user!
	
	def new
	end

	def create
		args = {
		  email:                params[:document][:email],
		  phone_number:         params[:document][:phone_number],
		  ip:                   params[:document][:ip],
		  name:                 params[:document][:name],
		  aka:                  params[:document][:name],
		  entity_type:          params[:document][:entity_type],
		  entity_scope:         params[:document][:entity_scope],
		  birth_day:            params[:document][:birth_day].to_i,
		  birth_month:          params[:document][:birth_month].to_i,
		  birth_year:           params[:document][:birth_year].to_i,
		  address_street:       params[:document][:address_street],
		  address_city:         params[:document][:address_city],
		  address_subdivision:  params[:document][:address_subdivision],
		  address_postal_code:  params[:document][:address_postal_code],
		  address_country_code: params[:document][:address_country_code]
		}
	

		user = SynapsePayRest::User.find(client: $client, id: current_user.synapse_id )
		base_doc = user.create_base_document(args)


		virtual_doc = SynapsePayRest::VirtualDocument.create(
		  type:  'SSN',
		  value: params[:document][:ssn]
		)

		base_doc = base_doc.add_virtual_documents(virtual_doc)

		physical_doc = SynapsePayRest::PhysicalDocument.create(
			  type:  'GOVT_ID',
			  file_path: params[:document][:govt_id].path
		)

		base_doc = base_doc.add_physical_documents(physical_doc)


		redirect_to donations_path

		
		rescue SynapsePayRest::Error => e
	    flash[:error] = e.message
	    redirect_to documents_path
	

	end
end
