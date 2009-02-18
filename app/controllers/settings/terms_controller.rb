class Settings::TermsController < SettingsController
	layout "standard"

	def index
		@terms = Term.find(:all,
					:select => 'id, school_year, count(*) as total_terms, min(begin_date) as begin_date, max(end_date) as end_date',
					:group	=> 'school_year',
					:order	=> 'max(end_date) DESC')
	end

	def edit
		@terms = Term.find_all_by_school_year(params[:id])
	end
	
	def update
		@terms = Term.find_all_by_school_year(params[:school_year])

		respond_to do |format|
			if Term.update_terms(params[:term])
				flash[:notice] = "School Year '#{params[:school_year]}' was successfully updated."
				format.html { redirect_to(terms_path) }
			else
				flash[:error] = "School Year '#{params[:school_year]}' failed to update."
				format.html { render :action => :edit }
			end
		end
		
	end
end
