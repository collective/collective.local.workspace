*** Settings ***

Resource  plone/app/robotframework/keywords.robot
Resource  plone/app/robotframework/saucelabs.robot

Test Setup  Run keywords  Open SauceLabs test browser
Test Teardown  Run keywords  Report test status  Close all browsers


*** Keywords ***
a Site Owner
    Log in as site owner

Mail configured
    Go to  ${PLONE_URL}/@@mail-controlpanel
    Input text  form.smtp_host  localhost
    Input text  form.smtp_port  9025
    Input text  form.email_from_name  Administrateur
    Input text  form.email_from_address  admin@monportail.fr
    Click Button  form.actions.save

Add user to plone site
    [Arguments]   ${fullname}  ${username}
    Go to  ${PLONE_URL}/@@usergroup-userprefs
    Wait until page contains element  css=form.link-overlay
    Click button  css=form.link-overlay .add
    Overlay is opened
    Wait Until Page Contains Element  zc.page.browser_form
    Input text  form.fullname  ${fullname}
    Input text  form.username  ${username}
    Input text  form.email  ${username}@example.com
    Input text  form.password  ${username}
    Input text  form.password_ctl  ${username}
    Unselect Checkbox  form.mail_me
    Click button  form.actions.register

Close Overlay
    Click Element  css=div.overlay div.close

Overlay should close
    Wait until keyword succeeds  60  1  Element should not remain visible  id=exposeMask
    Wait until keyword succeeds  60  1  Page should not contain element  css=div.overlay

Overlay is opened
    Wait Until Page Contains Element  css=.overlay

Add new
    [Arguments]   ${name}
    Open Add New Menu
    Click link  css=#plone-contentmenu-factories a#${name}
    Wait Until Page Contains Element  css=#form

I add a workspace
    Go to  ${PLONE_URL}
    Add new  workspace
    Input text  form-widgets-IBasic-title  My workspace
    Click Button    form-buttons-save

I add a workspace member
    [Arguments]   ${fullname}  ${username}  ${group_id}
    Go to  ${PLONE_URL}/my-workspace/@@sharing
    Click link  new-user-link
    Overlay is opened
    Wait Until Page Contains Element  zc.page.browser_form
    Input text  form.fullname  ${fullname}
    Input text  form.username  ${username}
    Input text  form.email  ${username}@example.com
    # form.roles
    Unselect checkbox  form.roles.3
    Select checkbox  form.groups.${group_id}
    Click button  form.actions.register
    Overlay should close

I add a workspace group
    [Arguments]   ${name}  ${title}  ${description}  ${local_role_id}
    Click link  new-group-link
    Overlay is opened
    Wait Until Page Contains Element  createGroup
    Input text  addname  ${name}
    Input text  title  ${title}
    Input text  description:text  ${description}
    Select checkbox  form.localroles.${local_role_id}
    Submit form  createGroup
    Overlay should close


*** Test cases ***

Add a workspace
    Given a Site Owner
    I add a workspace
    Page should contain  My workspace


Add groups to workspace
    Given a Site Owner
    And Mail configured
    I add a workspace
    Go to  ${PLONE_URL}/my-workspace/@@sharing
    I add a workspace group  contributors  Contributors  Workspace contributors  0
    I add a workspace group  moderators  Moderators  Workspace moderators  1
    I add a workspace group  readers  Readers  Workspace readers  3


Add members to workspace
    Given a Site Owner
    And Mail configured
    I add a workspace
    Go to  ${PLONE_URL}/my-workspace/@@sharing
    I add a workspace group  contributors  Contributors  Workspace contributors  0
    I add a workspace member  Marie Durand  mdurand  0


Add an existing member to workspace
    Given a Site Owner
    And Mail configured
    Add user to plone site  Pierre Durand  pdurand
    I add a workspace
    Go to  ${PLONE_URL}/my-workspace/@@sharing
    Input text  sharing-user-group-search  Pierre
    Click button  sharing-search-button
    Wait until page contains  Pierre Durand
    Select checkbox  css=tr.odd input[name='entries.role_Reader:records']
    Click button  sharing-save-button
    Go to  ${PLONE_URL}/my-workspace/@@userlisting
    Wait Until Page Contains  Members
    Page should contain  Pierre Durand


Add a user to a group
    Given a Site Owner
    And Mail configured
    Add user to plone site  Pierre Durand  pdurand
    I add a workspace
    Go to  ${PLONE_URL}/my-workspace/@@sharing
    I add a workspace group  contributors  Contributors  Workspace contributors  0
    Click link  css=ul#groups-list li:first-child a
    Overlay is opened
    Input text  searchstring  Pierre
    Click button  css=.overlay input[name='form.button.Search']
    Wait until page contains element  css=.overlay input[value='pdurand']
    Select checkbox  css=.overlay input[value='pdurand']
    Click button  css=.overlay input[name='form.button.Add']
    Wait until page contains element  css=.info
    Close Overlay
    Click link  css=ul#groups-list li:first-child a
    Overlay is opened
    Page should contain  Pierre Durand


Send mail to a group
    Given a Site Owner
    And Mail configured
    I add a workspace
    Go to  ${PLONE_URL}/my-workspace/@@sharing
    I add a workspace group  contributors  Contributors  Workspace contributors  0
    I add a workspace member  Marie Durand  mdurand  0
    I add a workspace member  Pierre Durand  pdurand  0
    Click link  css=#contentview-sendtolisting a
    Input text  mailing_list_email_subject  Message to workspace contributors
    Select checkbox  Contributor.selectButton
    Execute javascript  tinyMCE.getInstanceById('email_body').setContent("<p>Hello,</p><p>You can now add content to this <strong>workspace</strong>.</p><p>Thank you,</p><p>The workspace administrator</p>")
