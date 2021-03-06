class SmsAdapter < ApplicationAdapter
  def status
    # imposible to get it
  end

  def start(time)
    raise ApplicationAdapter::Error, 'Phone must be presene' if machine.phone.blank?

    # Example 'KRSL:TC00570 mas5 end'
    message="KRSL:#{machine.internal_id} mas#{time} end"
    SmsService.call(machine.phone, message)
    log_success_acitity time
  rescue StandardError => err
    Bugsnag.notify err
    log_failed_acivity time, err
  end
end
