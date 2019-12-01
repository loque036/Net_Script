:: ### User and localgroup managment script ###
:: ### By loque036 ###

:: ### script customizations ###
@echo off

title User and localgroup management script

:: ### check for administrator privileges ### 

goto admin_perms

:admin_perms

    net session >nul 2>&1
    if %errorLevel% == 0 (
        goto begin
    ) else (
        echo Please run this program with administrator privileges.
    )

    pause >nul
 
:begin

:: ### main menu ###

:main_menu
cls

echo.
echo Simple script that manages user accounts.
echo Made by loque036 ( https://github.com/loque036 ).
echo.
echo Choose an option: 
echo.
echo 1. Create user account.
echo 2. Manage an existing user account.
echo 3. Create a local group.
echo 4. Manage an existing local group.
echo 5. Exit.
echo.

:: ### choose an option ### 
set /p op=Choose: 
if "%op%"=="1" goto create_user
if "%op%"=="2" goto manage_user
if "%op%"=="3" goto create_group
if "%op%"=="4" goto manage_group
if "%op%"=="5" goto end

:: ### user stuff goes in first ###
:: ### creating a new user ### 

:create_user
cls
echo.
echo You have chosen to create a new user account.
set /p user=Please type the name of the new user account: 
net user %user% /add
echo.

:: ### ask to add a password ### 

echo Do you want to add a password to your new user?
set /p pw=Press Y to add a password, else press N:  
if "%pw%"=="y" goto pwy
if "%pw%"=="n" goto pwn

:: ### add a password ### 

:pwy
net user %user% *
PING localhost -n 2 >NUL

:: ### more options ### 

echo Password added. Do you want to do something else?
set /p moreop=Press Y to show more options, else press N: 
if "%moreop%"=="y" goto manage_user_adv
if "%moreop%"=="n" goto main_menu

:: ### no password ### 

:pwn
echo No password will be added
PING localhost -n 2 >NUL
goto manage_user_adv

:: ### option 2 ### 

:manage_user
cls
echo.
PING localhost -n 2 >NUL
net user
set /p user=Please select the account you want to manage: 
goto manage_user_adv

:: ### user managing part ### 
:: ### more options ###

:manage_user_adv
cls
echo.
echo More options for account %user%:
echo.
echo 1. Set account %user% as active or inactive.
echo 2. Add a comment to account %user%.
echo 3. The user %user% can change their password.
echo 4. The user %user% requires a password.
echo 5. The user %user% must change their password at the next logon.
echo 6. Delete selected user.
echo 7. Go back to main menu
echo 8. Exit program.
echo.

set /p manage_user_adv_choice=Choose: 

if %manage_user_adv_choice%==1 goto manage_user_adv_1
if %manage_user_adv_choice%==2 goto manage_user_adv_2
if %manage_user_adv_choice%==3 goto manage_user_adv_3
if %manage_user_adv_choice%==4 goto manage_user_adv_4
if %manage_user_adv_choice%==5 goto manage_user_adv_5
if %manage_user_adv_choice%==6 goto manage_user_adv_6
if %manage_user_adv_choice%==7 goto manage_user_adv_7
if %manage_user_adv_choice%==8 goto manage_user_adv_8

:: ### set account as active or inactive ###

:manage_user_adv_1
cls
set /p active=If you want to set the user %user% as active, type active, else type inactive: 
if "%active%"==yes goto manage_user_adv_1_active
if "%active%"==no goto manage_user_adv_1_inactive

:: ### active account ###

:manage_user_adv_1_active
net user %user% /active:yes
PING localhost -n 2 >NUL
goto manage_user_adv

:: ### inactive account ###

:manage_user_adv_1_inactive
net user %user% /active:no
PING localhost -n 2 >NUL
goto manage_user_adv

:: ### add comment ###
:manage_user_adv_2
cls
set /p comment=Please type the comment you want to add to the account %user% (if you want to remove the comment press enter): 
net user %user% /comment:"%comment%"
PING localhost -n 2 >NUL
goto manage_user_adv

:: ### allow the user to change their password or not ###

:manage_user_adv_3
cls
set /p chgpwd=Allow %user% to change their password? (type yes or no):  
if "%chgpwd%"==yes goto manage_user_adv_3_chgpwd_yes
if "%chgpwd%"==no goto manage_user_adv_3_chgpwd_no

:: ### allow to change password ###

:manage_user_adv_3_chgpwd_yes
net user %user% /passwordchg:yes
PING localhost -n 2 >NUL
goto manage_user_adv

:: ### don't allow to change password ###

:manage_user_adv_3_chgpwd_no
net user %user% /passwordchg:no
PING localhost -n 2 >NUL
goto manage_user_adv

:: ### decide if the user requires to have a password ###

:manage_user_adv_4
cls
set /p reqpwd=Will the user %user% require a password? (type yes or no):  
if "%reqpwd%"==yes goto manage_user_adv_4_reqpwd_yes
if "%reqpwd%"==no goto manage_user_adv_4_reqpwd_no

:: ### user requires a password ###

:manage_user_adv_4_reqpwd_yes
net user %user% /passwordchg:yes
PING localhost -n 2 >NUL
goto manage_user_adv

:: ### user does not require a password ###

:manage_user_adv_4_reqpwd_no
net user %user% /passwordchg:no
PING localhost -n 2 >NUL
goto manage_user_adv

:: ### user much change their password at the next logon ###

:manage_user_adv_5
cls
set /p newpwd=Will the user %user% change their password at the next logon? (type yes or no):  
if "%reqpwd%"==yes goto manage_user_adv_4_newpwd_yes
if "%reqpwd%"==no goto manage_user_adv_4_newpwd_no

:: ### user has to change their password ###

:manage_user_adv_5_newpwd_yes
net user %user% /logonpasswordchg:yes
PING localhost -n 2 >NUL
goto manage_user_adv

:: ### user does not have to change their password ###

:manage_user_adv_5_newpwd_no
net user %user% /logonpasswordchg:no
PING localhost -n 2 >NUL
goto manage_user_adv

:: ### delete account ###

:manage_user_adv_6
cls
echo WARNING! This action cannot be undone.
pause
net user %user% /delete
PING localhost -n 2 >NUL
goto main_menu

:: ### go to main menu ###

:manage_user_adv_7
cls
goto main_menu

:: ### exit ###

:manage_user_adv_8
cls
goto end

:: ### localgroup stuff ###
:: ### creating a new localgroup ### 

:create_group
cls
echo.
echo You have chosen to create a new user account.
set /p localgroup=Please type the name of the new localgroup: 
net localgroup %localgroup% /add

:: ### localgroup managing part ### 
:: ### more options ###

:manage_group
cls
echo.
PING localhost -n 2 >NUL
net localgroup
set /p localgroup=Please select the localgroup you want to manage: 
goto manage_localgroup_adv

:: ### localgroup managing part ### 
:: ### more options ###

:manage_localgroup_adv

cls
echo.
echo More options for localgroup %localgroup%:
echo.
echo 1. Add user to this localgroup.
echo 2. Remove user from this localgroup.
echo 3. Add a comment to localgroup %localgroup%.
echo 4. Delete this localgroup.
echo 5. Go back to main menu.
echo 6. Exit program.
echo.

set /p manage_user_adv_choice=Choose: 

if %manage_user_adv_choice%==1 goto manage_localgroup_adv1
if %manage_user_adv_choice%==2 goto manage_localgroup_adv2
if %manage_user_adv_choice%==3 goto manage_localgroup_adv3
if %manage_user_adv_choice%==4 goto manage_localgroup_adv4
if %manage_user_adv_choice%==5 goto manage_localgroup_adv5
if %manage_user_adv_choice%==6 goto manage_localgroup_adv6

:: ### add a user to current localgroup ###

:manage_localgroup_adv1

cls
echo.
net user
echo.
set /p user=What user do you want to add to the localgroup?: 
net localgroup %localgroup% %user% /add
PING localhost -n 2 >NUL
goto :manage_localgroup_adv

:: ### remove user from current localgroup ###

:manage_localgroup_adv2

cls
echo.
net localgroup %localgroup%
echo.
set /p user=What user do you want to remove from the localgroup?: 
net localgroup %localgroup% %user% /delete
PING localhost -n 2 >NUL
goto :manage_localgroup_adv

:: ### add comment to current localgroup ###

:manage_localgroup_adv3
cls
echo.
set /p comment=What's the comment that you want to add to the localgroup?: 
net localgroup %localgroup% /comment:"%comment%"
PING localhost -n 2 >NUL
goto :manage_localgroup_adv

:: ### delete current localgroup ###

:manage_localgroup_adv4
cls
echo.
echo WARNING! This action cannot be undone.
pause
net localgroup %localgroup% /delete
PING localhost -n 2 >NUL
goto main_menu

:: ### go back to main menu ###

:manage_localgroup_adv5
cls
goto main_menu

:: ### exit the program ###

:manage_localgroup_adv6
cls
goto end

:end
exit