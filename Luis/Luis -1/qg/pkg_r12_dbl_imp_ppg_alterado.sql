CREATE OR REPLACE PACKAGE BODY PKG_R12_DBL_IMP IS

/******************************************************************************/
/* Autor        : Marcos R. Carneiro                                          */
/* Data Criação : Agosto e Setembro de 2012.                                  */
/* Propósito    : Interfaces para Extracao de Dados do Oracle eBusiness Suite */
/*                R12 com Utilização de DBLINK.                               */
/*                Tratamento Geral das Interfaces de Entrada                  */
/******************************************************************************/
  --
--  CONS_COMMIT_BLOCK        CONSTANT NUMBER       := 25;
  CONS_MSG_NOTIF_DUPLICADA CONSTANT VARCHAR2(50) := 'Desconsiderada por Duplicidade';
  --
  function GET_PROCESSA_ERROR_MSG(p_s_ConstraintName in varchar2)
    return varchar2 is

    s_MSG             varchar2(250);
    s_ContraintType   varchar2(1);
    s_NomeContraintFK varchar2(30);
    s_NomeTabela      varchar2(30);
    s_NomeTabelaFK    varchar2(30);
    s_NomeColuna      varchar2(100);
    s_NomeColunas     varchar2(4000);
    s_CondicaoViolada varchar2(4000);

    cursor Busca_Colunas is
      select COLUMN_NAME
        from USER_CONS_COLUMNS
       where CONSTRAINT_NAME = p_s_ConstraintName;

    cursor Busca_ColunasFK is
      select COLUMN_NAME, TABLE_NAME
        from USER_CONS_COLUMNS
       where CONSTRAINT_NAME = s_NomeContraintFK;

  begin

    select CONSTRAINT_TYPE, R_CONSTRAINT_NAME, TABLE_NAME, SEARCH_CONDITION

      into s_ContraintType,
           s_NomeContraintFK,
           s_NomeTabela,
           s_CondicaoViolada

      from USER_CONSTRAINTS

     where CONSTRAINT_NAME = p_s_ConstraintName;

    if sql%notfound then
      return Null;
    End if;

    if s_ContraintType = 'P' then
      /* Constraint é de Chave Primária */
      s_NomeColunas := Null;
      s_NomeColuna  := Null;

      -- Buscar as colunas envolvidas
      open Busca_Colunas;
      Loop
        fetch Busca_Colunas
          into s_NomeColuna;
        exit when Busca_Colunas%notfound;
        if s_NomeColunas is Null then
          s_NomeColunas := s_NomeColunas || s_NomeColuna;
        else
          s_NomeColunas := s_NomeColunas || ', ' || s_NomeColuna;
        end if;
      End loop;
      close Busca_Colunas;

      -- Processa a Mensagem
      s_MSG := 'Tentativa de inserir na tabela ' || s_NomeTabela ||
               ' falhou. A chave primária foi violada, esta chave é composta da(s) coluna(s) (' ||
               s_NomeColunas || ').';

    Elsif s_ContraintType = 'R' then
      /* Constraint é de Chave Estrangeira */
--      s_NomeColunas := Null;
      s_NomeColuna  := Null;

      -- Busca a Coluna que é Chave Estrangeira
      open Busca_ColunasFK;
      fetch Busca_ColunasFK
        into s_NomeColuna, s_NomeTabelaFK;
      if Busca_ColunasFK%notfound then
        return Null;
      End if;
      close Busca_ColunasFK;

      -- Processa a mensagem
      s_MSG := 'Tentativa de inserir um registro na tabela ' ||
               s_NomeTabela || ' falhou. O conteúdo da coluna ' ||
               s_NomeColuna || ' não está cadastrado na tabela ' ||
               s_NomeTabelaFK || '.';

    Elsif s_ContraintType = 'U' then
      /* Constraint á de Unique Constraint */
      s_NomeColunas := Null;
      s_NomeColuna  := Null;

      -- Buscar as colunas envolvidas
      open Busca_Colunas;
      Loop
        fetch Busca_Colunas
          into s_NomeColuna;
        exit when Busca_Colunas%notfound;
        if s_NomeColunas is Null then
          s_NomeColunas := s_NomeColunas || s_NomeColuna;
        else
          s_NomeColunas := s_NomeColunas || ', ' || s_NomeColuna;
        end if;
      End loop;
      close Busca_Colunas;

      -- Processa a Mensagem
      s_MSG := 'Tentativa de inserir na tabela ' || s_NomeTabela ||
               ' falhou. Uma restrição que deve ser única foi violada, esta chave é composta da(s) coluna(s) (' ||
               s_NomeColunas || ').';

    Elsif s_ContraintType = 'C' then
      /* Constraint é de Check */

      -- Busca a Coluna que é Chave Estrangeira
      open Busca_Colunas;
      fetch Busca_Colunas
        into s_NomeColuna;
      if Busca_Colunas%notfound then
        return Null;
      End if;
      close Busca_Colunas;

      -- Processa a Mensagem
      s_MSG := 'Tentativa de inserir na tabela ' || s_NomeTabela ||
               ' falhou. A coluna ' || s_NomeColuna ||
               ' está assumindo um valor inválido, ela deve respeitar a seguinte condição: ' ||
               s_CondicaoViolada || '.';

    End if;

    return s_MSG;

    /*Caso ocorra algum tipo de erro com as tabelas*/
  Exception
    When Others Then
      Return Null;

  end GET_PROCESSA_ERROR_MSG;

  function GET_CONSTRAINT_NAME_MSG(s_MSG in varchar2) return varchar2 is

    n_pos            number;
    s_ConstraintName varchar2(250) := s_MSG;

  begin

    n_pos := instr(s_ConstraintName, 'constraint (');

    if n_pos > 0 then
      s_ConstraintName := substr(s_ConstraintName,
                                 n_pos,
                                 length(s_ConstraintName) - n_pos);

      n_pos := instr(s_ConstraintName, '.');

      if n_pos > 0 then

        s_ConstraintName := substr(s_ConstraintName,
                                   n_pos + 1,
                                   length(s_ConstraintName) - n_pos);

        n_pos := instr(s_ConstraintName, ')');

        s_ConstraintName := substr(s_ConstraintName, 1, n_pos - 1);

      else
        s_ConstraintName := null;
      end if;
    else
      s_ConstraintName := null;
    end if;

    return s_ConstraintName;

  end GET_CONSTRAINT_NAME_MSG;

  procedure OIF_MSG_ERRO_SQL(p_v_Status out VARCHAR2) is
    -- Procedure Data
    v_Constraint VARCHAR2(250) := NULL;
    v_Msg        VARCHAR2(250);
    -- PL/SQL Block
  begin
    v_Msg        := substr(SQLERRM(SQLCODE()), 1, 250);
    v_Constraint := GET_CONSTRAINT_NAME_MSG(v_Msg);
    if v_Constraint is not null then
      p_v_Status := GET_PROCESSA_ERROR_MSG(v_Constraint);
    end if;
    p_v_Status := substr(p_v_Status || ' - ' || v_Msg, 1, 250);
  end OIF_MSG_ERRO_SQL;

  PROCEDURE GERA_MSG_ERRO_INOUT(p_n_ID_IMPORTACAO     IN NUMBER,
                                p_n_NOTIFICATION_ID   IN NUMBER,
                                p_s_EVENT_NAME        IN VARCHAR2,
                                p_s_TRANSACTION_TYPE  IN VARCHAR2,
                                p_s_PARAMETER_VALUE1  IN VARCHAR2,
                                p_s_PARAMETER_VALUE2  IN VARCHAR2,
                                p_s_PARAMETER_VALUE3  IN VARCHAR2,
                                p_s_PARAMETER_VALUE4  IN VARCHAR2,
                                p_s_PARAMETER_VALUE5  IN VARCHAR2,
                                p_s_PARAMETER_VALUE6  IN VARCHAR2,
                                p_s_PARAMETER_VALUE7  IN VARCHAR2,
                                p_s_PARAMETER_VALUE8  IN VARCHAR2,
                                p_s_PARAMETER_VALUE9  IN VARCHAR2,
                                p_s_PARAMETER_VALUE10 IN VARCHAR2,
                                p_n_ERROS_LOADER      IN NUMBER,
                                p_s_MSG_ERRO1         IN VARCHAR2,
                                p_s_MSG_ERRO2         IN VARCHAR2,
                                p_s_MSG_ERRO3         IN VARCHAR2,
                                p_s_MSG_ERRO4         IN VARCHAR2,
                                p_s_MSG_ERRO5         IN VARCHAR2) IS
--    s_Entidade_INOUT varchar2(250);
    s_Linha1         varchar2(250);
    s_Linha2         varchar2(250);

    PROCEDURE INSERE_LOG_INOUT(p_n_ID_IMPORTACAO IN NUMBER,
                               p_s_MENSAGEM      IN VARCHAR2) IS
--      var_clob     clob;
--      tam_mensagem BINARY_INTEGER;
--      tam_clob     NUMBER;
    BEGIN
       --
       PROC_IO_INFORMA_OBS_ID_IMPORTA(p_n_ID_IMPORTACAO, p_s_MENSAGEM);
       --
    END;

  BEGIN
    --
    -- Monta Strings
    s_Linha1 := 'TRX_ID=' || to_char(p_n_NOTIFICATION_ID) || ',' ||
                'EVENTO=' || p_s_EVENT_NAME || '(' ||
                p_s_TRANSACTION_TYPE || '),' || 'OPERACAO=' ||
                p_s_TRANSACTION_TYPE || '(' ||
                p_s_TRANSACTION_TYPE || ')';
    s_Linha2 := 'PK_1 =' || TRIM(nvl(p_s_PARAMETER_VALUE1,  'nulo')) || ',' ||
                'PK_2 =' || TRIM(nvl(p_s_PARAMETER_VALUE2,  'nulo')) || ',' ||
                'PK_3 =' || TRIM(nvl(p_s_PARAMETER_VALUE3,  'nulo')) || ',' ||
                'PK_4 =' || TRIM(nvl(p_s_PARAMETER_VALUE4,  'nulo')) || ',' ||
                'PK_5 =' || TRIM(nvl(p_s_PARAMETER_VALUE5,  'nulo')) || ',' ||
                'PK_6 =' || TRIM(nvl(p_s_PARAMETER_VALUE6,  'nulo')) || ',' ||
                'PK_7 =' || TRIM(nvl(p_s_PARAMETER_VALUE7,  'nulo')) || ',' ||
                'PK_8 =' || TRIM(nvl(p_s_PARAMETER_VALUE8,  'nulo')) || ',' ||
                'PK_9 =' || TRIM(nvl(p_s_PARAMETER_VALUE9,  'nulo')) || ',' ||
                'PK_10=' || TRIM(nvl(p_s_PARAMETER_VALUE10, 'nulo'));
    --
    if p_n_erros_loader = 1 then
      INSERE_LOG_INOUT(p_n_ID_IMPORTACAO, lpad('-', 250, '-') || CHR(10));
      INSERE_LOG_INOUT(p_n_ID_IMPORTACAO, 'ERROS LOADER' || CHR(10));
    end if;
    --
    INSERE_LOG_INOUT(p_n_ID_IMPORTACAO, lpad('-', 250, '-') || CHR(10));
    INSERE_LOG_INOUT(p_n_ID_IMPORTACAO, s_Linha1 || CHR(10));
    INSERE_LOG_INOUT(p_n_ID_IMPORTACAO, s_Linha2 || CHR(10));
    --
    if (p_s_msg_erro1 is not null) then
      INSERE_LOG_INOUT(p_n_ID_IMPORTACAO, p_s_MSG_ERRO1 || CHR(10));
    end if;
    if (p_s_msg_erro2 is not null) then
      INSERE_LOG_INOUT(p_n_ID_IMPORTACAO, p_s_MSG_ERRO2 || CHR(10));
    end if;
    if (p_s_msg_erro3 is not null) then
      INSERE_LOG_INOUT(p_n_ID_IMPORTACAO, p_s_MSG_ERRO3 || CHR(10));
    end if;
    if (p_s_msg_erro4 is not null) then
      INSERE_LOG_INOUT(p_n_ID_IMPORTACAO, p_s_MSG_ERRO4 || CHR(10));
    end if;
    if (p_s_msg_erro5 is not null) then
      INSERE_LOG_INOUT(p_n_ID_IMPORTACAO, p_s_MSG_ERRO5 || CHR(10));
    end if;
    --
  END GERA_MSG_ERRO_INOUT;

--  PROCEDURE INSERE_NOTIFICACAO_HISTORICO(p_n_ID_IMPORTACAO IN NUMBER) IS
  PROCEDURE ATUALIZA_NOTIFICACAO IS
    CURSOR c_Notif IS(SELECT NOTIFICATION_ID
                      FROM   R12_DBL_T_F255_NOTIFICATIONS
                      WHERE  EXPORT_STATUS = 2);
    r_Notif c_Notif%ROWTYPE;
    --
    CURSOR c_Notif_Erro IS(SELECT NOTIFICATION_ID,
                                  RETURN_MESSAGE
                           FROM   R12_DBL_T_F255_NOTIFICATIONS
                           WHERE  EXPORT_STATUS = 4);
    r_Notif_Erro c_Notif_Erro%ROWTYPE;
    --
    s_Comando_Sql  VARCHAR2(32000);
    s_Where        VARCHAR2(30000);
    n_Contador     NUMBER;
    --
  BEGIN
     --
     s_Where    := NULL;
     n_Contador := 0;
     open c_Notif;
     loop
       fetch c_Notif
         into r_Notif;
       --
       if (n_Contador = 1000) or
          ((c_Notif%notfound) and (s_Where is not null)) then
         s_Where := rtrim(s_Where, ',');
        --
/*
        execute immediate 'DELETE SFWBR_CLL_F255_NOTIFICATIONS
      WHERE NOTIFICATION_ID IN (' || s_Where || ')';

        execute immediate 'DELETE R12_DBL_T_F255_NOTIFICATIONS
      WHERE NOTIFICATION_ID IN (' || s_Where || ')';
*/
         s_Comando_Sql := 'DELETE SFWBR_CLL_F255_NOTIFICATIONS
         WHERE NOTIFICATION_ID IN (' || s_Where || ')';
         --
         EXECUTE IMMEDIATE s_Comando_Sql;
         --
         s_Comando_Sql := 'DELETE R12_DBL_T_F255_NOTIFICATIONS
         WHERE NOTIFICATION_ID IN (' || s_Where || ')';
         --
         EXECUTE IMMEDIATE s_Comando_Sql;
         --
         s_Where    := NULL;
         n_Contador := 0;
       end if;
       --
       exit when c_Notif%notfound;
       --
       s_Where    := s_Where || to_char(r_Notif.NOTIFICATION_ID) || ',';
       n_Contador := n_Contador + 1;
       --
     end loop;
     close c_Notif;
     --
/*
    s_Comando_Sql := 'UPDATE SFWBR_CLL_F255_NOTIFICATIONS SET EXPORT_STATUS = 4
    WHERE NOTIFICATION_ID IN (';
*/
     --
     s_Where := NULL;
     open c_Notif_Erro;
     loop
       fetch c_Notif_Erro
         into r_Notif_Erro;
       --
       if (n_Contador = 1) or
          ((c_Notif_Erro%notfound) and (s_Where is not null)) then
          s_Where := rtrim(s_Where, ',');
          --
          s_Comando_Sql := 'UPDATE SFWBR_CLL_F255_NOTIFICATIONS SET EXPORT_STATUS = 4, RETURN_MESSAGE = ''' ||
                           r_Notif_Erro.RETURN_MESSAGE ||
                           ''' WHERE NOTIFICATION_ID in (' || s_Where || ')';
          --
          EXECUTE IMMEDIATE s_Comando_Sql;
          --
--        execute immediate 'UPDATE SFWBR_CLL_F255_NOTIFICATIONS SET EXPORT_STATUS = 4, RETURN_MESSAGE = ''' ||
--                          r_Notif_Erro.RETURN_MESSAGE ||
--                          ''' WHERE NOTIFICATION_ID in (' || s_Where || ')';
          --
          s_Comando_Sql :=  'DELETE R12_DBL_T_F255_NOTIFICATIONS
          where NOTIFICATION_ID in (' || s_Where || ')';
          --
          EXECUTE IMMEDIATE s_Comando_Sql;
          --
          s_Where    := NULL;
          n_Contador := 0;
       end if;
       --
       exit when c_Notif_Erro%notfound;
       --
       s_Where    := to_char(r_Notif_Erro.NOTIFICATION_ID);
       n_Contador := n_Contador + 1;
       --
     end loop;
     close c_Notif_Erro;
     --
  END ATUALIZA_NOTIFICACAO;

  PROCEDURE ELIMINA_NOTIFICACAO_DUPLICADA IS
    s_Update VARCHAR2(4000);
  BEGIN
    FOR r_Notif IN (SELECT COUNT(1),
                           ISV_NAME,
                           EVENT_NAME,
                           PARAMETER_VALUE1,
                           PARAMETER_VALUE2,
                           PARAMETER_VALUE3,
                           PARAMETER_VALUE4,
                           PARAMETER_VALUE5,
                           PARAMETER_VALUE6,
                           PARAMETER_VALUE7,
                           PARAMETER_VALUE8,
                           PARAMETER_VALUE9,
                           PARAMETER_VALUE10,
                           MAX(NOTIFICATION_ID) MAX_ID
                    FROM   R12_DBL_T_F255_NOTIFICATIONS
                    GROUP  BY ISV_NAME,
                              EVENT_NAME,
                              PARAMETER_VALUE1,
                              PARAMETER_VALUE2,
                              PARAMETER_VALUE3,
                              PARAMETER_VALUE4,
                              PARAMETER_VALUE5,
                              PARAMETER_VALUE6,
                              PARAMETER_VALUE7,
                              PARAMETER_VALUE8,
                              PARAMETER_VALUE9,
                              PARAMETER_VALUE10
                    HAVING    COUNT(1) > 1) LOOP

--      s_Update := 'UPDATE SFW_T_CLL_F255_NOTIFICATIONS
      s_Update := 'UPDATE R12_DBL_T_F255_NOTIFICATIONS
                   SET    EXPORT_STATUS  = 2,
                          RETURN_MESSAGE = ''' ||
                   CONS_MSG_NOTIF_DUPLICADA || ''' ' ||
                  'WHERE  NOTIFICATION_ID < ' || to_char(r_Notif.MAX_ID);
      --
      -- Varchar ID's
      if (r_Notif.PARAMETER_VALUE1 is not null) then
        s_Update := s_Update || ' and PARAMETER_VALUE1  = ''' ||
                    r_Notif.PARAMETER_VALUE1 || '''';
      end if;
      if (r_Notif.PARAMETER_VALUE2 is not null) then
        s_Update := s_Update || ' and PARAMETER_VALUE2  = ''' ||
                    r_Notif.PARAMETER_VALUE2 || '''';
      end if;
      if (r_Notif.PARAMETER_VALUE3 is not null) then
        s_Update := s_Update || ' and PARAMETER_VALUE3  = ''' ||
                    r_Notif.PARAMETER_VALUE3 || '''';
      end if;
      if (r_Notif.PARAMETER_VALUE4 is not null) then
        s_Update := s_Update || ' and PARAMETER_VALUE4  = ''' ||
                    r_Notif.PARAMETER_VALUE4 || '''';
      end if;
      if (r_Notif.PARAMETER_VALUE5 is not null) then
        s_Update := s_Update || ' and PARAMETER_VALUE5  = ''' ||
                    r_Notif.PARAMETER_VALUE5 || '''';
      end if;
      if (r_Notif.PARAMETER_VALUE6 is not null) then
        s_Update := s_Update || ' and PARAMETER_VALUE6  = ''' ||
                    r_Notif.PARAMETER_VALUE6 || '''';
      end if;
      if (r_Notif.PARAMETER_VALUE7 is not null) then
        s_Update := s_Update || ' and PARAMETER_VALUE7  = ''' ||
                    r_Notif.PARAMETER_VALUE7 || '''';
      end if;
      if (r_Notif.PARAMETER_VALUE8 is not null) then
        s_Update := s_Update || ' and PARAMETER_VALUE8  = ''' ||
                    r_Notif.PARAMETER_VALUE8 || '''';
      end if;
      if (r_Notif.PARAMETER_VALUE9 is not null) then
        s_Update := s_Update || ' and PARAMETER_VALUE9  = ''' ||
                    r_Notif.PARAMETER_VALUE9 || '''';
      end if;
      if (r_Notif.PARAMETER_VALUE10 is not null) then
        s_Update := s_Update || ' and PARAMETER_VALUE10 = ''' ||
                    r_Notif.PARAMETER_VALUE10 || '''';
      end if;
      --
      execute immediate s_Update;
      --
    END LOOP;
    -- Trata evento 'oracle.apps.cll.po_releases'
    FOR r_Notif_po_release IN (SELECT COUNT(1),
                           ISV_NAME,
                           EVENT_NAME,
                           PARAMETER_VALUE2,
                           PARAMETER_VALUE3,
                           MAX(NOTIFICATION_ID) MAX_ID
                    FROM   SFWBR_CLL_F255_NOTIFICATIONS
                     where event_name = 'oracle.apps.cll.po_releases'
                     and export_status = 1
                    GROUP  BY ISV_NAME,
                              EVENT_NAME,
                              PARAMETER_VALUE2,
                              PARAMETER_VALUE3
                    HAVING    COUNT(1) > 1) LOOP

--      s_Update := 'UPDATE SFW_T_CLL_F255_NOTIFICATIONS
      s_Update := 'UPDATE SFWBR_CLL_F255_NOTIFICATIONS
                   SET    EXPORT_STATUS  = 2,
                          RETURN_MESSAGE = ''' ||
                   CONS_MSG_NOTIF_DUPLICADA || ''' ' ||
                  'WHERE NOTIFICATION_ID < ' || to_char(r_Notif_po_release.MAX_ID);
      --
      if (r_Notif_po_release.PARAMETER_VALUE2 is not null) then
        s_Update := s_Update || ' and PARAMETER_VALUE2  = ''' ||
                    r_Notif_po_release.PARAMETER_VALUE2 || '''';
      end if;

      if (r_Notif_po_release.PARAMETER_VALUE2 is not null) then
        s_Update := s_Update || ' and PARAMETER_VALUE3  = ''' ||
                    r_Notif_po_release.PARAMETER_VALUE3 || '''';
      end if;

      s_Update := s_Update || ' and event_name = ''oracle.apps.cll.po_releases''';

      execute immediate s_Update;

     --
    END LOOP;
    --
	-- Trata evento 'oracle.apps.cll.ri.invoiceLines'
    FOR r_Notif_po_release IN (SELECT COUNT(1),
                           ISV_NAME,
                           EVENT_NAME,
                           PARAMETER_VALUE1,
                           MAX(NOTIFICATION_ID) MAX_ID
                    FROM   SFWBR_CLL_F255_NOTIFICATIONS
                     where event_name = 'oracle.apps.cll.ri.invoiceLines'
                     and export_status = 1
                    GROUP  BY ISV_NAME,
                              EVENT_NAME,
                              PARAMETER_VALUE1
                    HAVING    COUNT(1) > 1) LOOP

--      s_Update := 'UPDATE SFW_T_CLL_F255_NOTIFICATIONS
      s_Update := 'UPDATE SFWBR_CLL_F255_NOTIFICATIONS
                   SET    EXPORT_STATUS  = 2,
                          RETURN_MESSAGE = ''' ||
                   CONS_MSG_NOTIF_DUPLICADA || ''' ' ||
                  'WHERE NOTIFICATION_ID < ' || to_char(r_Notif_po_release.MAX_ID);
      --
      s_Update := s_Update || ' and event_name = ''oracle.apps.cll.ri.invoiceLines''';
	  
	  s_Update := s_Update || ' and PARAMETER_VALUE1  = ''' ||
                    r_Notif_po_release.PARAMETER_VALUE1 || '''';
	  
	  execute immediate s_Update;
	   
	  END LOOP;
	  
  END ELIMINA_NOTIFICACAO_DUPLICADA;

  PROCEDURE DESPREZA_NOTIFICACAO (p_s_EVENT_NAME IN VARCHAR2) IS
  BEGIN
     --
     if p_s_EVENT_NAME in ('oracle.apps.cll.po_headers') then
        -- Desconsidera Notif. de Pedidos/Itens de fornecedores nacionais...
        delete from SFWBR_CLL_F255_NOTIFICATIONS N
        where  N.ISV_NAME      = CONS_COD_PARCEIRO
        and    N.EXPORT_STATUS in (1,4)
        and    N.EVENT_NAME    = p_s_EVENT_NAME
        and    exists (select 1
                       from   SFWBR_PO_PED_COMPRAS_V PO

                       where  PO.PO_HEADER_ID = TO_NUMBER(N.PARAMETER_VALUE1)
                       and    nvl(PO.COD_MOEDA,'BRL') = 'BRL');
     end if;
     --
     if p_s_EVENT_NAME in ('oracle.apps.cll.oe_order_headers') then
       if NVL(FNC_R12_DBL_REGRA_CONFIGURACAO('ORDEM_PROCESSO_DESPREZA_PAIS_BR', NULL),'S') = 'S' then
         delete from SFWBR_CLL_F255_NOTIFICATIONS N
          where N.EVENT_NAME = p_s_EVENT_NAME
            and N.ISV_NAME = CONS_COD_PARCEIRO
            and exists
          (select 1
                   from SFWBR_OM_PEDIDOS_VENDAS_V P, SFWBR_AR_CLIENTES_V C
                  where P.HEADER_ID = TO_NUMBER(N.PARAMETER_VALUE1)
                    and P.ID_SITE_ENTREGA_PARA = C.SITE_USE_ID
                    and C.PAIS = 'BR');
       end if;
     end if;
     --
     if p_s_EVENT_NAME in ('oracle.apps.cll.ra_customer_trx') then
       if NVL(FNC_R12_DBL_REGRA_CONFIGURACAO('NOTA_FISCAL_EXPORTACAO_CFOP', NULL),'S') = 'S' then
         delete from SFWBR_CLL_F255_NOTIFICATIONS N
          where N.EVENT_NAME = p_s_EVENT_NAME
            and N.ISV_NAME = CONS_COD_PARCEIRO
            and exists
          (select 1
                   from SFWBR_AR_NFS_V NF
                  where NF.CUSTOMER_TRX_ID = TO_NUMBER(N.PARAMETER_VALUE1)
                    and NF.COD_CFO is null);
       end if;
     end if;
     --
     if p_s_EVENT_NAME in ('oracle.apps.cll.wsh_new_deliveries') then
       if NVL(FNC_R12_DBL_REGRA_CONFIGURACAO('ORDEM_PROCESSO_DESPREZA_PAIS_BR',NULL),'S') = 'S' THEN
         delete from SFWBR_CLL_F255_NOTIFICATIONS N
          where N.EVENT_NAME = p_s_EVENT_NAME
            and N.ISV_NAME = CONS_COD_PARCEIRO
            and (not exists
                 (select 1
                    from SFWBR_OM_ENTREGAS_V       E,
                         SFWBR_OM_PEDIDOS_VENDAS_V P,
                         SFWBR_AR_CLIENTES_V       C
                   where P.HEADER_ID = E.SOURCE_HEADER_ID
                     and E.DELIVERY_ID = TO_NUMBER(N.PARAMETER_VALUE1)
                     and P.ID_SITE_ENTREGA_PARA = C.SITE_USE_ID
                     and C.PAIS != 'BR'));
       end if;
     end if;
-- Início Alteração - Marcos R. Carneiro - Chamado: 412394...
     IF p_s_EVENT_NAME IN ('oracle.apps.bom.structure.created','oracle.apps.bom.structure.modified') THEN
        DELETE FROM SFWBR_CLL_F255_NOTIFICATIONS N1
        WHERE  N1.NOTIFICATION_ID IN (SELECT N2.NOTIFICATION_ID
                                      FROM   SFWBR_CLL_F255_NOTIFICATIONS N2
                                      WHERE  N2.ISV_NAME    = CONS_COD_PARCEIRO
                                      AND    N2.EVENT_NAME  IN ('oracle.apps.bom.structure.created','oracle.apps.bom.structure.modified')
                                      AND    N2.RETURN_CODE = 0
                                     )
        AND    N1.PARAMETER_NAME3 IS NOT NULL;
     END IF;
-- Final Alteração - Marcos R. Carneiro - Chamado: 412394...
  END DESPREZA_NOTIFICACAO;

  PROCEDURE CARREGA_NOTIFICACAO(p_s_EVENT_NAME             IN VARCHAR2,
                                p_n_QTDE_NOTIF_A_PROCESSAR IN NUMBER,
                                p_n_REPROCESSA_ERROS       IN NUMBER) IS
    s_Comando_SQL  VARCHAR2(4000);
    s_Where_Status VARCHAR2(50);
  BEGIN
     -- Não Processa Erros (somente STATUS = 1)
     IF (p_n_REPROCESSA_ERROS = 0) THEN
         s_Where_Status := 'and    EXPORT_STATUS    = 1';
           -- Processo Todas Notificacoes (STATUS 1 e 4)
     ELSIF (p_n_REPROCESSA_ERROS = 1) THEN
            s_Where_Status := 'and    EXPORT_STATUS    in (1,4)';
           -- Somente Processa Notificacoes com Erros (somente STATUS = 4)
     ELSIF (p_n_REPROCESSA_ERROS = 2) THEN
            s_Where_Status := 'and    EXPORT_STATUS    = 4';
     END IF;
     --
     -- Constroi comando SQL para carregar EXPORT_DATA
--     s_Comando_SQL := 'INSERT INTO SFW_T_CLL_F255_NOTIFICATIONS
     s_Comando_SQL := 'INSERT INTO R12_DBL_T_F255_NOTIFICATIONS
     (NOTIFICATION_ID,
      ISV_NAME,
      EVENT_KEY,
      EVENT_NAME,
      TRANSACTION_TYPE,
      CREATION_DATE,
      CREATED_BY,
      LAST_UPDATE_DATE,
      LAST_UPDATED_BY,
      LAST_UPDATE_LOGIN,
      REQUEST_ID,
      PROGRAM_APPLICATION_ID,
      PROGRAM_ID,
      PROGRAM_UPDATE_DATE,
      EXPORT_STATUS,
      PARAMETER_NAME1,
      PARAMETER_VALUE1,
      PARAMETER_NAME2,
      PARAMETER_VALUE2,
      PARAMETER_NAME3,
      PARAMETER_VALUE3,
      PARAMETER_NAME4,
      PARAMETER_VALUE4,
      PARAMETER_NAME5,
      PARAMETER_VALUE5,
      PARAMETER_NAME6,
      PARAMETER_VALUE6,
      PARAMETER_NAME7,
      PARAMETER_VALUE7,
      PARAMETER_NAME8,
      PARAMETER_VALUE8,
      PARAMETER_NAME9,
      PARAMETER_VALUE9,
      PARAMETER_NAME10,
      PARAMETER_VALUE10,
      RETURN_CODE,
      RETURN_MESSAGE)
     SELECT * FROM (SELECT NOTIFICATION_ID,
                           ISV_NAME,
                           EVENT_KEY,
                           EVENT_NAME,
                           TRANSACTION_TYPE,
                           CREATION_DATE,
                           CREATED_BY,
                           LAST_UPDATE_DATE,
                           LAST_UPDATED_BY,
                           LAST_UPDATE_LOGIN,
                           REQUEST_ID,
                           PROGRAM_APPLICATION_ID,
                           PROGRAM_ID,
                           PROGRAM_UPDATE_DATE,
                           EXPORT_STATUS,
                           PARAMETER_NAME1,
                           PARAMETER_VALUE1,
                           PARAMETER_NAME2,
                           PARAMETER_VALUE2,
                           PARAMETER_NAME3,
                           PARAMETER_VALUE3,
                           PARAMETER_NAME4,
                           PARAMETER_VALUE4,
                           PARAMETER_NAME5,
                           PARAMETER_VALUE5,
                           PARAMETER_NAME6,
                           PARAMETER_VALUE6,
                           PARAMETER_NAME7,
                           PARAMETER_VALUE7,
                           PARAMETER_NAME8,
                           PARAMETER_VALUE8,
                           PARAMETER_NAME9,
                           PARAMETER_VALUE9,
                           PARAMETER_NAME10,
                           PARAMETER_VALUE10,
                           RETURN_CODE,
                           RETURN_MESSAGE
                    FROM   SFWBR_CLL_F255_NOTIFICATIONS
                    WHERE  ISV_NAME    = '''  || CONS_COD_PARCEIRO || '''
                    AND    EVENT_NAME  = '''  || p_s_EVENT_NAME    || '''
                    AND    RETURN_CODE = 0'   || s_Where_Status    ||
                    'ORDER BY EXPORT_STATUS, NOTIFICATION_ID)
     WHERE  ROWNUM <= ' || to_char(p_n_QTDE_NOTIF_A_PROCESSAR);
     --
     execute immediate s_Comando_SQL;
     --
     ELIMINA_NOTIFICACAO_DUPLICADA;
     --
  END CARREGA_NOTIFICACAO;
  --
  PROCEDURE PROCESSA_NOTIFICACAO(p_n_ID_IMPORTACAO          IN NUMBER,
                                 p_n_QTDE_NOTIF_A_PROCESSAR IN NUMBER,
                                 p_s_EVENT_NAME             IN VARCHAR2,
                                 p_n_REPROCESSA_ERROS       IN NUMBER) IS
    CURSOR c_Notif IS SELECT NOTIFICATION_ID,
                             ISV_NAME,
                             EVENT_KEY,
                             EVENT_NAME,
                             TRANSACTION_TYPE,
                             CREATION_DATE,
                             CREATED_BY,
                             LAST_UPDATE_DATE,
                             LAST_UPDATED_BY,
                             LAST_UPDATE_LOGIN,
                             REQUEST_ID,
                             PROGRAM_APPLICATION_ID,
                             PROGRAM_ID,
                             PROGRAM_UPDATE_DATE,
                             EXPORT_STATUS,
                             PARAMETER_NAME1,
                             PARAMETER_VALUE1,
                             PARAMETER_NAME2,
                             PARAMETER_VALUE2,
                             PARAMETER_NAME3,
                             PARAMETER_VALUE3,
                             PARAMETER_NAME4,
                             PARAMETER_VALUE4,
                             PARAMETER_NAME5,
                             PARAMETER_VALUE5,
                             PARAMETER_NAME6,
                             PARAMETER_VALUE6,
                             PARAMETER_NAME7,
                             PARAMETER_VALUE7,
                             PARAMETER_NAME8,
                             PARAMETER_VALUE8,
                             PARAMETER_NAME9,
                             PARAMETER_VALUE9,
                             PARAMETER_NAME10,
                             PARAMETER_VALUE10,
                             RETURN_CODE,
                             RETURN_MESSAGE
                      FROM   R12_DBL_T_F255_NOTIFICATIONS
                      WHERE  EXPORT_STATUS in (decode(p_n_REPROCESSA_ERROS, 0, 1, 1, 1, 0),
                                               decode(p_n_REPROCESSA_ERROS, 1, 4, 2, 4, 0))
                      AND    EVENT_NAME    = p_s_EVENT_NAME
                      ORDER  BY EXPORT_STATUS,
                                NOTIFICATION_ID;

    r_Notif         c_Notif%ROWTYPE;
    v_tmp_table_cst VARCHAR2(1)    := NULL;
--    v_evento_cst    VARCHAR2(1)    := NULL;
    v_s_Msg_Erro    VARCHAR2(2000) := NULL;
  BEGIN
     n_Qtde_Sucesso          := 0;
     n_Qtde_Sucesso_Entidade := 0;
     n_Qtde_Erro             := 0;

     dbms_lob.createtemporary(clob_Msg, TRUE, dbms_lob.session);

     BEGIN
        --
        DESPREZA_NOTIFICACAO(p_s_EVENT_NAME);
        --
        PKG_R12_DBL_IMP_T_TABLE.LIMPA_T_TABLES;
        --
        ELIMINA_NOTIFICACAO_DUPLICADA;

        CARREGA_NOTIFICACAO(p_s_EVENT_NAME,
                            p_n_QTDE_NOTIF_A_PROCESSAR,
                            p_n_REPROCESSA_ERROS);
        --
-- Falta Tratamento...
-- Talvez, fazer um DE_PARA dos Eventos...
/*
        IF v_tmp_table_cst = 'S' then
           gs_Comando_SQL_01 := 'BEGIN
           PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_' ||
                             trim(p_s_EVENT_NAME) || ';
           END;';
        ELSE
           gs_Comando_SQL_01 := 'BEGIN
           PKG_R12_DBL_IMP_T_TABLE.EVENTO_' ||
                             trim(p_s_EVENT_NAME) || ';
           END;';
        END IF;
*/
--
-- Interfaces de Entrada - BG...
--
   -- Interface: BG - IN - R12DBL - Clientes
      -- EVENT_NAME (XXISV_SOFTWAY_EVENTS): oracle.apps.softway.hz.customer
      -- EVENT_NAME (ORACLE): oracle.apps.cll.hz_cust_accounts / oracle.apps.cll.hz_cust_acct_sites_all
   -- Interface: BG - IN - R12DBL - Condições de Pagamentos de Exportação
      -- EVENT_NAME (XXISV_SOFTWAY_EVENTS): oracle.apps.softway.ra.payment_term
      -- EVENT_NAME (ORACLE): oracle.apps.cll.ra_terms_tl
   -- Interface: BG - IN - R12DBL - Fabricantes
      -- EVENT_NAME (XXISV_SOFTWAY_EVENTS): oracle.apps.softway.inv.manufacturer
      -- EVENT_NAME (ORACLE): oracle.apps.cll.mtl_manufacturers
   -- Interface: BG - IN - R12DBL - Fornecedores
      -- EVENT_NAME (XXISV_SOFTWAY_EVENTS): oracle.apps.softway.hz.supplier
      -- EVENT_NAME (ORACLE): oracle.apps.cll.ap_suppliers
   -- Interface: BG - IN - R12DBL - Condições de Pagamentos de Importação
      -- EVENT_NAME (XXISV_SOFTWAY_EVENTS): oracle.apps.softway.ap.terms
      -- EVENT_NAME (ORACLE): oracle.apps.cll.ap_terms_tl
   -- Interface: BG - IN - R12DBL - Produtos
      -- EVENT_NAME (XXISV_SOFTWAY_EVENTS): oracle.apps.softway.inv.item
      -- EVENT_NAME (ORACLE): oracle.apps.cll.mtl_system_items_b
   -- Interface: BG - IN - R12DBL - Transportadoras
      -- EVENT_NAME (XXISV_SOFTWAY_EVENTS): oracle.apps.softway.hz.freight_fowarder
      -- EVENT_NAME (ORACLE): oracle.apps.cll.hz_parties
--
-- Interfaces de Entrada - IS...
--
   -- Interface: IS - IN - R12DBL - Ordens de Compras
      -- EVENT_NAME (XXISV_SOFTWAY_EVENTS): oracle.apps.softway.po.purchase.approve
      -- EVENT_NAME (ORACLE): oracle.apps.cll.po_headers
   -- Interface: IS - IN - R12DBL - Recebimento de Ordens
      -- EVENT_NAME (XXISV_SOFTWAY_EVENTS): oracle.apps.softway.cll.cll_f189_receiving
      -- EVENT_NAME (ORACLE): oracle.apps.cll.ri.invoiceLines
--
-- Interfaces de Entrada - ES...
--
   -- Interface: ES - IN - R12DBL - Ordens / Processos de Exportação
      -- EVENT_NAME (XXISV_SOFTWAY_EVENTS): oracle.apps.softway.om.sales.order / oracle.apps.softway.wsh.delivery.ship_confirmed
      -- EVENT_NAME (ORACLE): oracle.apps.cll.oe_order_headers / oracle.apps.cll.oe_order_lines / oracle.apps.cll.wsh_new_deliveries
   -- Interface: ES - IN - R12DBL - Retorno de Notas Fiscais de Exportação
      -- EVENT_NAME (XXISV_SOFTWAY_EVENTS): oracle.apps.softway.ar.customer_transaction
      -- EVENT_NAME (ORACLE): oracle.apps.cll.ra_customer_trx
--
-- Interfaces de Entrada - CI...
--
   -- Interface: CI - IN - R12DBL - Faturas de Serviço de Importação
      -- EVENT_NAME (XXISV_SOFTWAY_EVENTS): oracle.apps.softway.cll.ap_invoices
      -- EVENT_NAME (ORACLE): oracle.apps.cll.ap_invoices
--
-- Interfaces de Entrada - CE...
--
   -- Interface: CE - IN - R12DBL - Faturas de Serviço de Exportação
      -- EVENT_NAME (XXISV_SOFTWAY_EVENTS): oracle.apps.softway.ar.customer_transaction
      -- EVENT_NAME (ORACLE): oracle.apps.cll.ra_customer_trx
   -- Interface: CE - IN - R12DBL - Pró-Forma de Exportação (Adiantamento)
      -- EVENT_NAME (XXISV_SOFTWAY_EVENTS): oracle.apps.softway.ar.customer_transaction
      -- EVENT_NAME (ORACLE): oracle.apps.cll.ra_customer_trx

        IF v_tmp_table_cst = 'S' THEN
           IF p_s_EVENT_NAME = 'oracle.apps.cll.hz_parties' THEN
              gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_TRANSPORTADORAS; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ra_terms_tl' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_COND_PAGTO_EXP; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.hz_cust_accounts' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_CLIENTES; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.hz_cust_acct_sites_all' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_SITES_CLIENTES; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.mtl_manufacturers' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_FABRICANTES; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ap_suppliers' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_FORNECEDORES; END;';
           ELSIF p_s_EVENT_NAME in ('oracle.apps.cll.mtl_system_items_b','oracle.apps.cll.ri.setup.fiscalItems') THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_PRODUTOS; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.po_headers' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_ORDEM_COMPRA; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.po_releases' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_ORDEM_COMPRA; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ri.invoiceLines' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_RECEBIMENTO; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ap_terms_tl' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_COND_PAGTO_IMP; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.oe_order_headers' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_ORDEM_VENDA; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.oe_order_lines' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_ITENS_ORDEM_VENDA; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.wsh_new_deliveries' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_PROCESSO; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ra_customer_trx' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_NOTA_FISCAL; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ap_invoices' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_FATURA_SERVICO_CI; END;';
-- Início Alteração - Marcos R. Carneiro - Chamado: 336495...
           ELSIF p_s_EVENT_NAME = 'oracle.apps.bom.structure.created' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_BOM_ESTATICA; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.bom.structure.modified' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_BOM_ESTATICA; END;';
-- Final Alteração - Marcos R. Carneiro - Chamado: 336495...
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.fnd_territories_tl' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_PAISES; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.mtl_units_of_measure_tl' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE_CST.EVENTO_UNIDADE_MEDIDA; END;';
           END IF;
      ELSE
           IF p_s_EVENT_NAME = 'oracle.apps.cll.hz_parties' THEN
              gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_TRANSPORTADORAS; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ra_terms_tl' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_COND_PAGTO_EXP; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.hz_cust_accounts' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_CLIENTES; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.hz_cust_acct_sites_all' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_SITES_CLIENTES; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.mtl_manufacturers' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_FABRICANTES; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ap_suppliers' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_FORNECEDORES; END;';
           ELSIF p_s_EVENT_NAME in ('oracle.apps.cll.mtl_system_items_b','oracle.apps.cll.ri.setup.fiscalItems') THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_PRODUTOS; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.po_headers' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_ORDEM_COMPRA; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.po_releases' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_ORDEM_COMPRA; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ri.invoiceLines' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_RECEBIMENTO; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ap_terms_tl' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_COND_PAGTO_IMP; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.oe_order_headers' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_ORDEM_VENDA; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.oe_order_lines' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_ITENS_ORDEM_VENDA; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.wsh_new_deliveries' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_PROCESSO; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ra_customer_trx' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_NOTA_FISCAL; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ap_invoices' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_FATURA_SERVICO_CI; END;';
-- Início Alteração - Marcos R. Carneiro - Chamado: 336495...
           ELSIF p_s_EVENT_NAME = 'oracle.apps.bom.structure.created' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_BOM_ESTATICA; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.bom.structure.modified' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_BOM_ESTATICA; END;';
-- Final Alteração - Marcos R. Carneiro - Chamado: 336495...
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.fnd_territories_tl' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_PAISES; END;';
           ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.mtl_units_of_measure_tl' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_T_TABLE.EVENTO_UNIDADE_MEDIDA; END;';
           END IF;
        END IF;
        --
        EXECUTE IMMEDIATE gs_Comando_SQL_01;
        COMMIT;
        --
        OPEN c_Notif;
        LOOP
           FETCH c_Notif
           INTO  r_Notif;
           EXIT  WHEN c_Notif%notfound;
           --
           gs_Status_Notif := NULL;
           --
/*
           IF v_tmp_table_cst = 'S' then
              gs_Comando_SQL_01 := 'BEGIN
              PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_' ||
                               trim(r_Notif.EVENT_NAME)  || '(' ||
                                  to_char(r_Notif.NOTIFICATION_ID) || ',';
           ELSE
              gs_Comando_SQL_01 := 'BEGIN
              PKG_R12_DBL_IMP_EVENTO.EVENTO_' ||
                                  trim(r_Notif.EVENT_NAME)  || '(' ||
                                  to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                  to_char(p_n_ID_IMPORTACAO) || ',';
           END IF;
*/
           IF v_tmp_table_cst = 'S' THEN
              IF p_s_EVENT_NAME = 'oracle.apps.cll.hz_parties' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_TRANSPORTADORAS(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ra_terms_tl' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_COND_PAGTO_EXP(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.hz_cust_accounts' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_CLIENTES(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.hz_cust_acct_sites_all' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_SITES_CLIENTES(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.mtl_manufacturers' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_FABRICANTES(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ap_suppliers' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_FORNECEDORES(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
              ELSIF p_s_EVENT_NAME in ('oracle.apps.cll.mtl_system_items_b','oracle.apps.cll.ri.setup.fiscalItems') THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_PRODUTOS(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.po_headers' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_ORDEM_COMPRA(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.po_releases' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_ORDEM_COMPRA(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ri.invoiceLines' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_RECEBIMENTO(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ap_terms_tl' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_COND_PAGTO_IMP(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.oe_order_headers' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_ORDEM_VENDA(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.oe_order_lines' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_ITENS_ORDEM_VENDA(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.wsh_new_deliveries' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_PROCESSO(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ra_customer_trx' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_NOTA_FISCAL(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ap_invoices' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_FATURA_SERVICO_CI(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
-- Início Alteração - Marcos R. Carneiro - Chamado: 336495...
              ELSIF p_s_EVENT_NAME = 'oracle.apps.bom.structure.created' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_BOM_ESTATICA(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.bom.structure.modified' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_BOM_ESTATICA(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
-- Final Alteração - Marcos R. Carneiro - Chamado: 336495...
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.fnd_territories_tl' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_PAISES(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.mtl_units_of_measure_tl' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO_CST.EVENTO_UNIDADE_MEDIDA(' ||
                                          to_char(r_Notif.NOTIFICATION_ID) || ',';
              END IF;
           ELSE
              IF p_s_EVENT_NAME = 'oracle.apps.cll.hz_parties' THEN
                 gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_TRANSPORTADORAS(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ra_terms_tl' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_COND_PAGTO_EXP(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.hz_cust_accounts' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_CLIENTES(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.hz_cust_acct_sites_all' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_SITES_CLIENTES(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.mtl_manufacturers' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_FABRICANTES(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ap_suppliers' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_FORNECEDORES(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              ELSIF p_s_EVENT_NAME in ('oracle.apps.cll.mtl_system_items_b','oracle.apps.cll.ri.setup.fiscalItems') THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_PRODUTOS(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.po_headers' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_ORDEM_COMPRA(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.po_releases' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_ORDEM_COMPRA(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ri.invoiceLines' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_RECEBIMENTO(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ap_terms_tl' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_COND_PAGTO_IMP(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.oe_order_headers' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_ORDEM_VENDA(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.oe_order_lines' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_ITENS_ORDEM_VENDA(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.wsh_new_deliveries' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_PROCESSO(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ra_customer_trx' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_NOTA_FISCAL(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.ap_invoices' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_FATURA_SERVICO_CI(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
-- Início Alteração - Marcos R. Carneiro - Chamado: 336495...
              ELSIF p_s_EVENT_NAME = 'oracle.apps.bom.structure.created' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_BOM_ESTATICA(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.bom.structure.modified' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_BOM_ESTATICA(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
-- Final Alteração - Marcos R. Carneiro - Chamado: 336495...
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.fnd_territories_tl' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_PAISES(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              ELSIF p_s_EVENT_NAME = 'oracle.apps.cll.mtl_units_of_measure_tl' THEN
                    gs_Comando_SQL_01 := 'BEGIN PKG_R12_DBL_IMP_EVENTO.EVENTO_UNIDADE_MEDIDA(' ||
                                       to_char(r_Notif.NOTIFICATION_ID) || ',' ||
                                       to_char(p_n_ID_IMPORTACAO) || ',';
              END IF;
           END IF;
           --
           IF (r_Notif.PARAMETER_VALUE1 IS NOT NULL) THEN
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || '''' ||
                                   r_Notif.PARAMETER_VALUE1 || ''',';
           ELSE
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || 'NULL,';
           END IF;
           IF (r_Notif.PARAMETER_VALUE2 IS NOT NULL) THEN
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || '''' ||
                                   r_Notif.PARAMETER_VALUE2 || ''',';
           ELSE
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || 'NULL,';
           END IF;
           IF (r_Notif.PARAMETER_VALUE3 IS NOT NULL) THEN
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || '''' ||
                                   r_Notif.PARAMETER_VALUE3 || ''',';
           ELSE
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || 'NULL,';
           END IF;
           IF (r_Notif.PARAMETER_VALUE4 IS NOT NULL) THEN
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || '''' ||
                                   r_Notif.PARAMETER_VALUE4 || ''',';
           ELSE
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || 'NULL,';
           END IF;
           IF (r_Notif.PARAMETER_VALUE5 IS NOT NULL) THEN
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || '''' ||
                                   r_Notif.PARAMETER_VALUE5 || ''',';
           ELSE
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || 'NULL,';
           END IF;
           IF (r_Notif.PARAMETER_VALUE6 IS NOT NULL) THEN
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || '''' ||
                                   r_Notif.PARAMETER_VALUE6 || ''',';
           ELSE
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || 'NULL,';
           END IF;
           IF (r_Notif.PARAMETER_VALUE7 IS NOT NULL) THEN
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || '''' ||
                                   r_Notif.PARAMETER_VALUE7 || ''',';
           ELSE
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || 'NULL,';
           END IF;
           IF (r_Notif.PARAMETER_VALUE8 IS NOT NULL) THEN
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || '''' ||
                                   r_Notif.PARAMETER_VALUE8 || ''',';
           ELSE
             gs_Comando_SQL_01 := gs_Comando_SQL_01 || 'NULL,';
           END IF;
           IF (r_Notif.PARAMETER_VALUE9 IS NOT NULL) THEN
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || '''' ||
                                   r_Notif.PARAMETER_VALUE9 || ''',';
           ELSE
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || 'NULL,';
           END IF;
           IF (r_Notif.PARAMETER_VALUE10 IS NOT NULL) THEN
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || '''' ||
                                   r_Notif.PARAMETER_VALUE10 || ''',';
           ELSE
              gs_Comando_SQL_01 := gs_Comando_SQL_01 || 'NULL,';
           END IF;
           --
--           gs_Comando_SQL_01 := gs_Comando_SQL_01 || '); END;';
           gs_Comando_SQL_01 := rtrim(gs_Comando_SQL_01,',') || '); END;';
           --
           BEGIN
              EXECUTE IMMEDIATE gs_Comando_SQL_01;
              --
              UPDATE R12_DBL_T_F255_NOTIFICATIONS
              SET    EXPORT_STATUS = 2
              WHERE  NOTIFICATION_ID = r_Notif.NOTIFICATION_ID;
              --
              n_Qtde_Sucesso_Entidade := n_Qtde_Sucesso_Entidade + 1;
              --n_Qtde_Sucesso          := 0;
              --
              EXCEPTION
                 WHEN OTHERS THEN
                    ROLLBACK;
                    v_s_Msg_Erro := 'Loader Error: ' || SQLERRM;
                    --
                    UPDATE R12_DBL_T_F255_NOTIFICATIONS
                    SET    EXPORT_STATUS  = 4,
                           RETURN_MESSAGE = v_s_Msg_Erro
                    WHERE NOTIFICATION_ID = r_Notif.NOTIFICATION_ID;
                    --
                    n_Qtde_Erro    := n_Qtde_Erro + 1;
                    n_Qtde_Sucesso := 0;
                    --
                    IF SQLERRM LIKE '%ORA-20000%' THEN
                       GERA_MSG_ERRO_INOUT(p_n_ID_IMPORTACAO,
                                           r_Notif.NOTIFICATION_ID,
                                           r_Notif.EVENT_NAME,
                                           r_Notif.TRANSACTION_TYPE,
                                           r_Notif.PARAMETER_VALUE1,
                                           r_Notif.PARAMETER_VALUE2,
                                           r_Notif.PARAMETER_VALUE3,
                                           r_Notif.PARAMETER_VALUE4,
                                           r_Notif.PARAMETER_VALUE5,
                                           r_Notif.PARAMETER_VALUE6,
                                           r_Notif.PARAMETER_VALUE7,
                                           r_Notif.PARAMETER_VALUE8,
                                           r_Notif.PARAMETER_VALUE9,
                                           r_Notif.PARAMETER_VALUE10,
                                           n_Qtde_Erro,
                                           'Loader Error: ' ||
                                           REPLACE(SQLERRM, 'ORA-20000:', ''),
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL);
                    ELSE
                       GERA_MSG_ERRO_INOUT(p_n_ID_IMPORTACAO,
                                           r_Notif.NOTIFICATION_ID,
                                           r_Notif.EVENT_NAME,
                                           r_Notif.TRANSACTION_TYPE,
                                           r_Notif.PARAMETER_VALUE1,
                                           r_Notif.PARAMETER_VALUE2,
                                           r_Notif.PARAMETER_VALUE3,
                                           r_Notif.PARAMETER_VALUE4,
                                           r_Notif.PARAMETER_VALUE5,
                                           r_Notif.PARAMETER_VALUE6,
                                           r_Notif.PARAMETER_VALUE7,
                                           r_Notif.PARAMETER_VALUE8,
                                           r_Notif.PARAMETER_VALUE9,
                                           r_Notif.PARAMETER_VALUE10,
                                           n_Qtde_Erro,
                                           'Loader Error: NOTITICATION_ID= ' ||
                                           r_Notif.NOTIFICATION_ID || ' - ' ||
                                           SQLERRM,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL);
                    END IF;
           END;
           --
           COMMIT;
        END LOOP;
        --
        CLOSE c_Notif;
        --
--        INSERE_NOTIFICACAO_HISTORICO(p_n_ID_IMPORTACAO);
        ATUALIZA_NOTIFICACAO;
        --
        PROC_IO_INFORMA_QTDE_REGISTROS(p_n_ID_IMPORTACAO,
                                       n_Qtde_Sucesso_Entidade,
                                       n_Qtde_Erro);
        --
        EXCEPTION
           WHEN OTHERS THEN
              GERA_MSG_ERRO_INOUT(p_n_ID_IMPORTACAO,
                                  r_Notif.NOTIFICATION_ID,
                                  r_Notif.EVENT_NAME,
                                  r_Notif.TRANSACTION_TYPE,
                                  r_Notif.PARAMETER_VALUE1,
                                  r_Notif.PARAMETER_VALUE2,
                                  r_Notif.PARAMETER_VALUE3,
                                  r_Notif.PARAMETER_VALUE4,
                                  r_Notif.PARAMETER_VALUE5,
                                  r_Notif.PARAMETER_VALUE6,
                                  r_Notif.PARAMETER_VALUE7,
                                  r_Notif.PARAMETER_VALUE8,
                                  r_Notif.PARAMETER_VALUE9,
                                  r_Notif.PARAMETER_VALUE10,
                                  n_Qtde_Erro,
                                  'Error: ' || SQLERRM,
                                  NULL,
                                  NULL,
                                  NULL,
                                  NULL);
     END;
     --
     COMMIT;
     --
  END PROCESSA_NOTIFICACAO;
  --
END PKG_R12_DBL_IMP;
