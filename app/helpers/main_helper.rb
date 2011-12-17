module MainHelper
  
  def display_time(total_seconds)
      total_seconds = total_seconds.to_i

      days = total_seconds / 86400
      hours = (total_seconds / 3600) - (days * 24)
      minutes = (total_seconds / 60) - (hours * 60) - (days * 1440)
      seconds = total_seconds % 60

      display = ''
      display_concat = ''
      if days > 0
        display = display + display_concat + "#{days}d"
        display_concat = ' '
      end
      if hours > 0 || display.length > 0
        display = display + display_concat + "#{hours}h"
        display_concat = ' '
      end
      if minutes > 0 || display.length > 0
        display = display + display_concat + "#{minutes}m"
        display_concat = ' '
      end
      display = display + display_concat + "#{seconds}s"
      display
    end
end
