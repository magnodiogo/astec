require 'test_helper'

class SegurosFiancasControllerTest < ActionController::TestCase
  setup do
    @seguro_fianca = seguros_fiancas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:seguros_fiancas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create seguro_fianca" do
    assert_difference('SeguroFianca.count') do
      post :create, seguro_fianca: { cep: @seguro_fianca.cep, complemento: @seguro_fianca.complemento, danos_ao_imovel: @seguro_fianca.danos_ao_imovel, finalidade: @seguro_fianca.finalidade, imobiliaria_id: @seguro_fianca.imobiliaria_id, integer: @seguro_fianca.integer, integer: @seguro_fianca.integer, multa_recisoria: @seguro_fianca.multa_recisoria, numero: @seguro_fianca.numero, pintura_externa: @seguro_fianca.pintura_externa, pintura_interna: @seguro_fianca.pintura_interna, status: @seguro_fianca.status, string: @seguro_fianca.string, string: @seguro_fianca.string, string: @seguro_fianca.string, string: @seguro_fianca.string, tipo_do_imovel: @seguro_fianca.tipo_do_imovel, user_id: @seguro_fianca.user_id, valor_aluguel: @seguro_fianca.valor_aluguel, valor_condominio: @seguro_fianca.valor_condominio, valor_iptu: @seguro_fianca.valor_iptu }
    end

    assert_redirected_to seguro_fianca_path(assigns(:seguro_fianca))
  end

  test "should show seguro_fianca" do
    get :show, id: @seguro_fianca
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @seguro_fianca
    assert_response :success
  end

  test "should update seguro_fianca" do
    patch :update, id: @seguro_fianca, seguro_fianca: { cep: @seguro_fianca.cep, complemento: @seguro_fianca.complemento, danos_ao_imovel: @seguro_fianca.danos_ao_imovel, finalidade: @seguro_fianca.finalidade, imobiliaria_id: @seguro_fianca.imobiliaria_id, integer: @seguro_fianca.integer, integer: @seguro_fianca.integer, multa_recisoria: @seguro_fianca.multa_recisoria, numero: @seguro_fianca.numero, pintura_externa: @seguro_fianca.pintura_externa, pintura_interna: @seguro_fianca.pintura_interna, status: @seguro_fianca.status, string: @seguro_fianca.string, string: @seguro_fianca.string, string: @seguro_fianca.string, string: @seguro_fianca.string, tipo_do_imovel: @seguro_fianca.tipo_do_imovel, user_id: @seguro_fianca.user_id, valor_aluguel: @seguro_fianca.valor_aluguel, valor_condominio: @seguro_fianca.valor_condominio, valor_iptu: @seguro_fianca.valor_iptu }
    assert_redirected_to seguro_fianca_path(assigns(:seguro_fianca))
  end

  test "should destroy seguro_fianca" do
    assert_difference('SeguroFianca.count', -1) do
      delete :destroy, id: @seguro_fianca
    end

    assert_redirected_to seguros_fiancas_path
  end
end
