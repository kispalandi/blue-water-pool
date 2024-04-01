*** Settings ***
Resource    ../resources/common_resources.resource
Library    OperatingSystem

*** Variables ***
${URL}    https://bwpool.azurewebsites.net/   
${BROWSER}    Chrome
${EXPECTED_TITLE}    BWP Index
${USER_DATA_API}    https://random-data-api.com/api/users/random_user?size=1
${SESSION_NAME}    API Session

*** Keywords ***
Open Subject Website And Check the Title
    Open Browser    ${URL}    ${BROWSER}
    Title Should Be    ${EXPECTED_TITLE}

Test Teardown
    Close All Browsers

Navigate To Customer Menu
    Go To    ${URL}/Customer
    Click Element    ${CUSTOMER_MENU}
    Wait Until Element Is Visible    ${CUSTOMER_GRID}

Navigate To Locations Menu
    Go To    ${URL}/Location
    Click Element    ${LOCATIONS_MENU}
    Wait Until Element Is Visible    ${LOCATIONS_GRID}      

    [Arguments]    ${customer_name}    ${city}    ${zip_code}    ${street_name}    ${street_address}

*** Test Cases ***
Navigate To Customer Menu
    Open Browser To Login Page
    Navigate To Customer Menu

Api Call Test
    Create Session    ${SESSION_NAME}    ${USER_DATA_API}
    ${response}    Get On Session    ${SESSION_NAME}    ${USER_DATA_API}
    Should Be Equal As Strings    ${response.status_code}    200
    ${body}    Set Variable    ${response.json()}
    
    Log    ${body}

    ${first_name}    Set Variable    ${body}[0][first_name]
    ${last_name}    Set Variable    ${body}[0][last_name]
    ${email}    Set Variable    ${body}[0][email]
    ${id}    Set Variable    ${body}[0][id]

    Click Button    ${ADD_BUTTON}

    Wait Until Element Is Visible    ${CUSTOMER_NAME}    timeout=10s

    Input Text    ${CUSTOMER_NAME}    ${first_name} ${last_name}
    Input Text    ${E-MAIL_FIELD}    ${email}
    Input Text    ${COMMENT}    ${id}

    Click Button    ${SAVE_BUTTON}
    Wait Until Element Is Visible    ${CUSTOMER_GRID}    timeout=10s

# Navigate To Locations Menu
#     Open Location Menu

# Record User Location Data
#     Open Location Menu
#     Click Button    ${ADD_BUTTON}

#     Create Session    ${SESSION_NAME}    ${USER_DATA_API}
#     ${response}    Get On Session    ${SESSION_NAME}    ${USER_DATA_API}
#     Should Be Equal As Strings    ${response.status_code}    200
#     ${body}    Set Variable    ${response.json()}
    
#     Log    ${body}

#     ${city}    Set Variable    ${body}[0][city]
#     ${zip_code}    Set Variable    ${body}[0][zip_code]
#     ${street_name}    Set Variable    ${body}[0][street_name]
#     ${street_address}    Set Variable    ${body}[0][street_address]
#     Input Text    ${LOCATION_CUSTOMER}    ${CUSTOMER_NAME}
#     Select Checkbox    ${CUSTOMER_DROPDOWN}
#     Input Text    ${CITY}    ${city}
#     Input Text    ${ZIP_CODE}    ${zip_code}
#     Input Text    ${STREET_NAME}    ${street_name}
#     Input Text    ${HOUSE_NUMBER}    ${street_address}

#     Click Button    ${SAVE_BUTTON}
#     Wait Until Element Is Visible    ${LOCATIONS_GRID}    timeout=10s

Fill Customer Location Form
    Open Location Menu
    Click Button    ${ADD_BUTTON}    # Kattintás az űrlap hozzáadás gombjára
    Wait Until Element Is Visible    ${LOCATION_CUSTOMER}    timeout=10s    # Várakozás az ügyfél legördülő menü megjelenésére
    Select From List By Label    ${LOCATION_CUSTOMER_DROPDOWN}    ${customer_name}    # Ügyfél kiválasztása a legördülő menüből
    Input Text    ${CITY}    ${city}    # Város megadása
    Input Text    ${ZIP_CODE}    ${zip_code}    # Irányítószám megadása
    Input Text    ${STREET_NAME}    ${street_name}    # Utcanév megadása
    Input Text    ${STREET_ADDRESS}    ${street_address}    # Házszám megadása
    Click Button    ${SAVE_BUTTON}    # Űrlap mentése
    Wait Until Element Is Visible    ${LOCATIONS_GRID}    timeout=10s    # Várakozás a telephelyek táblázat megjelenésére