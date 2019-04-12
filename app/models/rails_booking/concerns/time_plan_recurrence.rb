module TimePlanRecurrence
  extend ActiveSupport::Concern

  included do
    attribute :repeat_type, :string, default: 'weekly'
    if defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter) && connection.is_a?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
      attribute :repeat_days, :json, default: {}
    else
      serialize :repeat_days, Hash
    end

    enum repeat_type: {
      once: 'once',
      weekly: 'weekly',
      monthly: 'monthly'
    }
  end

  def next_occurrence(now: Time.current)
    ts = time_items.select { |i| i.start_at.to_s(:time) > now.to_s(:time) }

  end

  def next_occurrences(start: Time.current, finish: start + 14.days)

  end

  def next_occurred_days(now: Time.current, limit: 1)
    days = self.repeat_days.keys
    r = []
    case self.repeat_type
    when 'weekly'
      first_days = days.select { |day| day.to_i >= now.days_to_week_start }
      first_days.each do |day|
        r << now.beginning_of_week.days_since(day.to_i)
        limit -= 1
        return r if limit.zero?
      end
      (1..).each do |week|
        days.each do |day|
          r << now.weeks_since(week).beginning_of_week.days_since(day.to_i)
          limit -= 1
          return r if limit.zero?
        end
      end
    when 'monthly'
      first_days = days.select { |day| day.to_i >= now.day }
      first_days.each do |day|
        r << now.beginning_of_month.days_since(day.to_i)
        limit -= 1
        return r if limit.zero?
      end
      (1..).each do |month|
        days.each do |day|
          r << now.weeks_since(month).beginning_of_month.days_since(day.to_i)
          limit -= 1
          return r if limit.zero?
        end
      end
    when 'once'
      first_days = days.select { |day| day.to_date >= now.to_date }
      first_days.each do |date|
        r << date
        limit -= 1
        return r if limit.zero?
      end
    end
    r
  end

  def next_days(start: Time.current, finish: start + 14.days)
    days = self.repeat_days.keys

    case self.repeat_type
    when 'weekly'
      (start.to_date .. finish.to_date).select { |date| days.include?(date.days_to_week_start.to_s) }
    when 'monthly'
      (start.to_date .. finish.to_date).select { |date| days.include?(date.day.to_s) }
    when 'once'
      (start.to_date .. finish.to_date).select { |date| days.include?(date.to_s) }
    end
  end


end
