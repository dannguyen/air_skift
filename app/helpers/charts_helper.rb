module ChartsHelper


  DEFAULTS = {
    credits: {
      enabled: false
    },
    title: nil,
    animation: false,
    tooltip:{
      backgroundColor: '#fff',
      borderRadius: 0,
      borderColor: '#aaa',
      style: {
        color: '#000',
        fontFamily: '"Helvetica Neue", Helvetica, Arial, sans-serif',
        padding: '5px',
      }
    }
  }


  def highchart_defaults(key=nil)
    if key.present?
      DEFAULTS[key.to_sym]
    else
      DEFAULTS
    end
  end

end
