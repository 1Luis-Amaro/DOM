DECLARE
    status BOOLEAN;
BEGIN
    status := FND_USER_PKG.CHANGEPASSWORD(username => 'D208211',
                                          newpassword => 'Oracle12345678');
    IF status
    THEN
        DBMS_OUTPUT.PUT_LINE('Password changed and user unlocked');
        commit;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error while setting password');
    END IF;
END;