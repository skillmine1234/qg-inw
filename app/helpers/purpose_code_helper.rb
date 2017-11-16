module PurposeCodeHelper
  # the options for the multi select are stored as a string in the database
  # while in the views we need an array, this helper helps!
  def convert_options_to_array(options_as_string)
    if (!options_as_string.nil?)
      options_as_string.split(',')
    else 
      []
    end
  end

  
  def disallowed_bene_and_rem_types_on_show_page(value)
    if (value == "I,C")
      "Individual,Corporates"
    elsif (value == "I")
      "Individual"
    elsif (value == "C")
      "Corporates"
    end
  end
  
  def find_purpose_codes(params)
    purpose_codes = PurposeCode
    purpose_codes = purpose_codes.where("code=?",params[:code]) if params[:code].present?
    purpose_codes = purpose_codes.where("is_enabled=?",params[:enabled]) if params[:enabled].present?
    purpose_codes
  end
end