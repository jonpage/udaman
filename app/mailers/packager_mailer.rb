class PackagerMailer < ActionMailer::Base
  default :from => "udaman@hawaii.edu"
  
  # def rake_notification(rake_task, download_string, error_string, summary_string)
  #   @download_string = download_string
  #   @error_string = error_string
  #   @summary_string = summary_string
  #   mail(:to => ["bentut@gmail.com","btrevino@hawaii.edu"], :subject => "UDAMAN New Download or Error (#{rake_task})")
  # end

  def rake_notification(rake_task, download_results, errors, series, output_path, is_error)
    @download_results = download_results
    @errors = errors
    @series = series
    @output_path = output_path
    @dates = Series.get_all_dates_from_data(@series)
    subject = "UDAMacMini Error (#{rake_task})" if is_error
    subject = "UDAMacMini New Download (#{rake_task})" unless is_error
    mail(:to => ["btrevino@hawaii.edu", "jrpage@hawaii.edu"], :subject => subject)
  end
  
  def rake_error(e, output_path)
    @error = e
    @output_path = output_path
    mail(:to => ["btrevino@hawaii.edu", "jrpage@hawaii.edu"], :subject => "Rake failed in an unexpected way (Udamacmini)")
  end

  def visual_notification(new_dps = 0, changed_files = 0, new_downloads = 0)
    attachments.inline['photo.png'] = File.read('/Users/uhero/Documents/udaman/script/investigate_visual.png')
    attachments['photo.png'] = File.read('/Users/uhero/Documents/udaman/script/investigate_visual.png')
    subject = "Udamacmini Download Report: #{new_dps.to_s + " new data points / " unless new_dps == 0} #{new_downloads.to_s + " updated downloads / " unless new_downloads == 0} #{changed_files.to_s + " modified update spreadsheets" unless changed_files == 0}"
    mail(:to => ["btrevino@hawaii.edu", "jrpage@hawaii.edu"], :subject => subject)
  end
  
  def download_link_notification(handle = nil, url = nil, save_path = nil, created = false)
    subject = "Udamacmini found and created a new download link for #{handle}" if created
    subject = "Udamacmini tried but failed to create a new download link for #{handle}" unless created
    @handle = handle
    @url = url
    @save_path = save_path
    mail(:to => ["btrevino@hawaii.edu", "jrpage@hawaii.edu"], :subject => subject)
  end
  
  def website_post_notification(post_name, post_address, new_data_series, created)
    subject = "Udamacmini: New data for #{post_name} posted to the UHERO website" if created
    subject = "Udamacmini tried but failed to post new data for #{post_name} to the UHERO website" unless created
    @post_address = post_address
    @new_data_series = new_data_series
    mail(:to => ["btrevino@hawaii.edu","jrpage@hawaii.edu"], :subject => subject) #{})
  end
  
  def prognoz_notification(recipients, send_edition)
    path = "~/data/prognoz_export/ready_to_send_zip_files/"
    filename = send_edition + ".zip"
    attachments[filename] = File.read(path+filename) 
    subject = "Prognoz Export (Udamacmini)"
    mail(:to => recipients, :subject => subject)  
  end
end
