*** Settings ***
Documentation       Fluxo de compra no site SauceDemo
Library             SeleniumLibrary
# Test Setup          Iniciar
Test Teardown       Encerrar


*** Variables ***
${url}          https://www.saucedemo.com/
${browser}      Chrome
${username}     standard_user
${password}     secret_sauce
${first_name}   Zoah
${last_name}    Zoah
${cep_zip}      00004511

*** Test Cases ***
Compra de bolsa
    [Tags]    SMOKE
    Dado que acesso o site Saucedemo
    E realizo o login
    Quando seleciono o filtro "mais barato para o mais caro"
    E seleciono "add to cart" no item desejado
    E acesso o carrinho
    E seleciono "Checkout" no carrinho
    E preencho os dados para continuar
    E finalizo a compra
    Então exibe a mensagem "THANK YOU FOR YOUR ORDER"

*** Keywords ***
Dado que acesso o site Saucedemo
    open browser    ${url}  ${browser}
    wait until element is visible   name:login-button
    wait for condition              return document.title == "Swag Labs"

E realizo o login
    input text                      name:user-name      ${username}
    input password                  name:password       ${password}
    click button                    name:login-button
    wait until element is visible   class:title

Quando seleciono o filtro "mais barato para o mais caro"
    select from list by label       class:product_sort_container    Price (low to high)
    element should be visible       class:inventory_item:nth-child(1) >> class:inventory_item_name   Sauce Labs Onesie

E seleciono "add to cart" no item desejado
    click button                    id:add-to-cart-sauce-labs-onesie

E acesso o carrinho
    click link                      class:shopping_cart_link
    element should contain          class:title      YOUR CART

E seleciono "Checkout" no carrinho
    click button                    id:checkout

E preencho os dados para continuar
    input text                      id:first-name    ${first_name}
    input text                      id:last-name     ${last_name}
    input text                      id:postal-code   ${cep_zip}
    click button                    id:continue

E finalizo a compra
    element text should be          class:title     CHECKOUT: OVERVIEW
    click button                    id:finish

Então exibe a mensagem "THANK YOU FOR YOUR ORDER"
    element text should be          class:complete-header   THANK YOU FOR YOUR ORDER


Encerrar
    close browser