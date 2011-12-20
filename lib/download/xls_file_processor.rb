#can use allow_blanks as an option for handling blanks
class XlsFileProcessor
  #job of this object is to coordinate all of the other processor objects for the mapping
  def initialize(handle, options, date_info, cached_files)
    @cached_files = cached_files
    @handle = handle
    @options = options
    @row_processor = IntegerPatternProcessor.new options[:row]
    @col_processor = IntegerPatternProcessor.new options[:col]
    @handle_processor = StringWithDatePatternProcessor.new handle
    @sheet_processor = StringWithDatePatternProcessor.new options[:sheet]
    @date_processor = DatePatternProcessor.new date_info[:start], options[:frequency], date_info[:rev]
  end

  def observation_at(index)
    date = @date_processor.compute(index)
  
    row = @row_processor.compute(index)
    col = @col_processor.compute(index)
    handle = @handle_processor.compute(date)
    sheet = @sheet_processor.compute(date)

    worksheet = @cached_files.xls(handle, sheet)
  
    observation_value = parse_cell(worksheet.cell(row,col))
    return "END" if observation_value == "BREAK IN DATA"
    {date => observation_value}
  end

  def parse_cell(cell_value)
    begin
      return Float cell_value
    rescue    
      #known data values that should be suppressed as nils... may need to separate these by file being read in
      return nil if ["(D) ", "(L) ", "(N) ", "(T) "].include? cell_value
      return "BREAK IN DATA"
    end
  end

end