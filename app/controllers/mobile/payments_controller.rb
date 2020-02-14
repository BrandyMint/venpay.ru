class Mobile::PaymentsController < Mobile::ApplicationController
  include AutoLogger

  def show
    payment = Payment.find params[:id]

    if payment.paid?
      # TODO Убедиться что по этому платежу машину включали,если нет, то запустить процесс включения
      render :success, locals: { payment: payment }
    else
      render locals: { payment: payment }
    end
  end

  def create
    payment = Payment.create! permitted_params

    logger.info "Create CloudPayments payment #{payment.id} for machine #{payment.machine.public_number} with #{payment.price.title}"
    redirect_to payment_path(payment)
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:error] = e.message
    Bugsnag.notify e

    redirect_back fallback: machines_path
  end

  def success
    # TODO
    #
    ## Убедиться что машину еще не включали.
    # 1. Если она уже включена то показывать страницу отсчета.
    # 2. Если была включена и закончила работу, то показывать
    #    страницу что по этой оплату кресло уже закончило массаж.
    # 3. Если машину еще не включали, то включить:
    #
    ## Включение машины

    machine.agent.start price.work_time
    #
    #
    # 2. Убедиться что машина включилась. Для этого нужно ловить exception.
    # 3. Логировать в Rails.logger что машину включили и результат (response)
    # 4. Показывать клиенту страницу что кресло включится через несколько секунд и показывтаь обратный отсчёт.
    #
    ## Если машина не включилась (поймали исключение), то:
    #
    # 1. Логировать исключение в Rails.logger
    # 2. Отправить уведомление в Bugsang с указанием price, machine, error
    # 3. Говорить клиенту что включение не удалось и возвращать деньги

    payment = Payment.find params[:id]
    render locals: { payment: payment }
  end

  def fail
    # TODO
    # 1. Сообщить админам (bugsnag)
    # 2. Записать в лог Rails.logger
    # 2. Сообщить пользователю причину.
    # 3. Дать возможность повторить оплату (например другой картой)
  end

  private

  def permitted_params
    params.permit(:machine_id, :price_id)
  end
end
