
GO
/****** Object:  StoredProcedure [dbo].[WMS_GOODSPLACEEXECSORT]    Script Date: 11/19/2020 11:17:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE          [dbo].[WMS_GOODSPLACEEXECSORT]
    (
        @BillGuid varchar(50) ,
        @billTemplateGuid varchar(50) ,
        @ProType  varchar(50), -- ���� 1=> ;2=>> ;3=<; 4=<<;5=���ƣ�6=���ƣ�7=�ö�;8=�õ�
        @SiteNum int ,-- ���
        @OperatorGuid varchar(50),-- ��ǰ������ԱGUID
        @ReturnMsg nvarchar(50) out,
        @ReturnValue int out
    )
    AS
    declare @count int;
    declare @Num int;
BEGIN
    select  @count = count(*)  from tt_selectguid where type='WMS_GoodsPlaceSort' and operatorguid=@OperatorGuid;
    if (@count=0)
    Begin
          set @ReturnMsg = '�޼�¼������ʧ�ܣ�' ;
          set @ReturnValue = -1 ;
          RETURN;
    End;
    Begin Tran
         update  WMS_GOODSPLACESORT set iszt='' where MAINGUID=@billguid and BILLTEMPLATEGUID=@BILLTEMPLATEGUID;
         IF @ProType = '1'
             Begin
                 -----------1.����������
                BEGIN
                    update WMS_GOODSPLACESORT set SORTNUMBER=ISNULL(SORTNUMBER,0)+ @COUNT where SORTNUMBER > ISNULL( @SiteNum,0) and BILLTEMPLATEGUID=@BILLTEMPLATEGUID and mainguid=@billguid ;
                    IF @@ERROR <> 0
                    Begin
                        set @ReturnMsg = '>��λ�����������';
                        GOTO SQLERR1;
                    end
                END;
                BEGIN
                    insert into WMS_GOODSPLACESORT(GUID,BILLTEMPLATEGUID,GOODSPLACEGUID,MAINGUID,SORTNUMBER,iszt)
                    SELECT NEWID(),@BILLTEMPLATEGUID,A.GUID,@BILLGUID,
                    A.DETAILNO+isnull(@SiteNum,0),'Y' FROM tt_selectguid A
                    LEFT JOIN (select guid ,GOODSPLACEGUID from WMS_GOODSPLACESORT where BILLTEMPLATEGUID=@BILLTEMPLATEGUID)B ON B.GOODSPLACEGUID=A.GUID
                    where A.type='WMS_GoodsPlaceSort' and A.operatorguid=@OperatorGuid AND B.GUID IS NULL ;
                    IF @@ERROR <> 0
                    Begin
                        Set @ReturnMsg = '>��λ����';
                        GOTO SQLERR1;
                    end

                END;

            End
        Else IF @ProType = '2'
        Begin
              -----------1.����������
                BEGIN
                    UPDATE A SET  A.SORTNUMBER=isnull(SORTNUMBER,0)+@COUNT  FROM WMS_GOODSPLACESORT A INNER JOIN tt_selectguid B ON A.GOODSPLACEGUID = B.Guid
                    WHERE type='WMS_GoodsPlaceSort' and operatorguid=@OperatorGuid AND A.BILLTEMPLATEGUID=@BILLTEMPLATEGUID AND A.SORTNUMBER> ISNULL(@SiteNum,0);
                    IF @@ERROR <> 0
                    Begin
                        set @ReturnMsg = '>>��λ�����������';
                        GOTO SQLERR1;
                    end
                END;
                      -----------2.�����¼�¼
                BEGIN
                    insert into WMS_GOODSPLACESORT(GUID,BILLTEMPLATEGUID,GOODSPLACEGUID,MAINGUID,SORTNUMBER,iszt)
                    SELECT NEWID(),@BILLTEMPLATEGUID,A.GUID,@BILLGUID,A.DETAILNO + ISNULL(@SiteNum,0),'Y' FROM tt_selectguid A
                    LEFT JOIN  (select guid ,GOODSPLACEGUID from WMS_GOODSPLACESORT where BILLTEMPLATEGUID=@BILLTEMPLATEGUID) B ON B.GOODSPLACEGUID=A.GUID
                    where A.type='WMS_GoodsPlaceSort' and A.operatorguid=@OperatorGuid   AND B.GUID IS NULL ;
                    IF @@ERROR <> 0
                    Begin
                        Set @ReturnMsg = '>>��λ����';
                        GOTO SQLERR1;
                    end

                END;
        End
        Else IF @ProType = '3'
             Begin
                BEGIN
                    DELETE FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =@BILLTEMPLATEGUID AND Mainguid=@BILLGUID AND GUID IN (SELECT GUID FROM  tt_selectguid where type='WMS_GoodsPlaceSort' and operatorguid=@OperatorGuid);
                    IF @@ERROR <> 0
                    Begin
                        set @ReturnMsg = '<��λ����';
                        GOTO SQLERR1;
                    end
                END;
                -- ��������
                Begin
                UPDATE A SET a.SORTNUMBER=b.SORTID FROM  WMS_GOODSPLACESORT a INNER JOIN (SELECT guid,ROW_NUMBER() OVER(partition by Mainguid ORDER BY SORTNUMBER) AS SORTID  FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =@BILLTEMPLATEGUID AND Mainguid=@BILLGUID) B ON A.GUID = B.GUID
                 IF @@ERROR <> 0
                 Begin
                    SET @ReturnMsg = '<��λ�������';
                    GOTO SQLERR1;
                 End
                End
            End
        Else IF @ProType = '4'
            Begin
                DELETE FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =@BILLTEMPLATEGUID AND Mainguid=@BILLGUID;
                IF @@ERROR <> 0
                Begin
                 Set @ReturnMsg = '<<��λ����';
                 GOTO SQLERR1;
                End
            End
    -------------------------------*********��λ***************----------------
        IF @ProType = '5'  ----------����
            Begin
                --------1.����ѡ���� ���ϵļ�¼
                BEGIN
                    update WMS_GOODSPLACESORT set SORTNUMBER=ISNULL(SORTNUMBER,0) + @COUNT  where SORTNUMBER=ISNULL(@SiteNum,0)-1 and BILLTEMPLATEGUID = @BILLTEMPLATEGUID and mainguid=@billguid ;
                    IF @@ERROR <> 0
                    Begin
                    Set @ReturnMsg = '������λ�����������';
                    GOTO SQLERR1;
                    End
                END;
                --------------2.����ѡ���е�λ��
                BEGIN
                    UPDATE A SET A.SORTNUMBER=ISNULL(SORTNUMBER,0) - 1 , iszt='Y' FROM WMS_GOODSPLACESORT A INNER JOIN  tt_selectguid B ON A.GUID = B.Guid WHERE  B.type='WMS_GoodsPlaceSort' and B.operatorguid=@OperatorGuid AND A.BILLTEMPLATEGUID=@BILLTEMPLATEGUID
                    IF @@ERROR <> 0
                    Begin
                    Set @ReturnMsg = '�����������';
                    GOTO SQLERR1;
                    End
                End
                --------��������
                Begin
                  UPDATE A SET  a.SORTNUMBER=b.SORTID  FROM  WMS_GOODSPLACESORT a INNER JOIN (SELECT guid,row_number() over(partition by Mainguid  order by SORTNUMBER) AS SORTID  FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =@BILLTEMPLATEGUID AND Mainguid=@BILLGUID)  B ON A.GUID = B.GUID
                  IF @@ERROR <> 0
                  Begin
                    Set @ReturnMsg = '�����������';
                    GOTO SQLERR1;
                  End
                End;
            End
        Else IF @ProType = '6' ------����
            Begin
                --------1.����ѡ���� ���ϵļ�¼
                Begin
                    update WMS_GOODSPLACESORT set SORTNUMBER=isnull(SORTNUMBER,0) - @count where SORTNUMBER=IsNull(@SiteNum,0) + @count and BILLTEMPLATEGUID=@BILLTEMPLATEGUID and mainguid=@billguid;
                    If @@ERROR <> 0
                    Begin
                       Set @ReturnMsg = '������λ�����������';
                       GOTO SQLERR1;
                    end
                End
                --------------2.����ѡ���е�λ��
                Begin
                    UPDATE A SET A.SORTNUMBER = ISNULL(SORTNUMBER,0) + 1 , iszt = 'Y' FROM WMS_GOODSPLACESORT A INNER JOIN tt_selectguid B ON A.GUID = B.Guid where type='WMS_GoodsPlaceSort' and operatorguid=@OperatorGuid AND A.BILLTEMPLATEGUID=@BILLTEMPLATEGUID
                    IF @@ERROR <> 0
                    Begin
                     SET @ReturnMsg = '�����������';
                     GOTO SQLERR1;
                    End
                END;
               --------��������
               Begin
                UPDATE A SET a.SORTNUMBER=b.SORTID FROM WMS_GOODSPLACESORT A INNER JOIN (SELECT guid,row_number() over(partition by Mainguid  order by SORTNUMBER) AS SORTID  FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =@BILLTEMPLATEGUID AND Mainguid=@BILLGUID) B ON A.GUID = B.GUID
                IF @@ERROR <> 0
                  Begin
                    Set @ReturnMsg = '�����������';
                    GOTO SQLERR1;
                  End
               End;
          End;
        Else IF @ProType = '7'
            Begin
              SELECT @Num = count(*)  FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =@BILLTEMPLATEGUID AND Mainguid= @BILLGUID;
              ----------------�ȸ��� ѡ��ļ�¼�� ���
                Begin
                    UPDATE A SET A.SORTNUMBER = ISNULL(SORTNUMBER,0) - @Num , iszt = 'Y'  FROM WMS_GOODSPLACESORT A INNER JOIN tt_selectguid B ON A.GUID = B.GUID where type='WMS_GoodsPlaceSort' and operatorguid=@OperatorGuid  AND A.BILLTEMPLATEGUID = @BILLTEMPLATEGUID
                    IF @@ERROR <> 0
                    Begin
                        SET @ReturnMsg = '�ö���λ�����������';
                        GOTO SQLERR1;
                    End
                End;
                 --------��������
                Begin
                    UPDATE A SET A.SORTNUMBER=B.SORTID  FROM WMS_GOODSPLACESORT A INNER JOIN (SELECT guid,row_number() over(partition by Mainguid  order by SORTNUMBER) AS SORTID  FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =@BILLTEMPLATEGUID AND Mainguid=@BILLGUID) B ON A.GUID = B.GUID
                     IF @@ERROR <> 0
                     Begin
                      Set @ReturnMsg = '�ö��������';
                      GOTO SQLERR1;
                     End
                End;
            End
        Else IF @ProType = '8' --�õ�
            Begin
                 SELECT @Num = count(*)  FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID = @BILLTEMPLATEGUID AND Mainguid = @BILLGUID;
                  ----------------�ȸ��� ѡ��ļ�¼�� ���
                 BEGIN
                    UPDATE A SET A.SORTNUMBER=ISNULL(SORTNUMBER,0) + @Num , iszt = 'Y'  FROM WMS_GOODSPLACESORT A INNER JOIN  tt_selectguid B ON A.GUID = B.Guid where type='WMS_GoodsPlaceSort' and operatorguid=@OperatorGuid AND A.BILLTEMPLATEGUID=@BILLTEMPLATEGUID
                    IF @@ERROR <> 0
                    Begin
                       Set @ReturnMsg = '�õ���λ�����������';
                       GOTO SQLERR1;
                    End
                END;
                     --------��������
                 Begin
                    UPDATE A SET a.SORTNUMBER=b.SORTID From  WMS_GOODSPLACESORT a INNER JOIN (SELECT guid,row_number() over(partition by Mainguid  order by SORTNUMBER) AS SORTID  FROM WMS_GOODSPLACESORT WHERE BILLTEMPLATEGUID =@BILLTEMPLATEGUID AND Mainguid = @BILLGUID) B ON A.GUID = B.GUID
                    IF @@ERROR <> 0
                    Begin
                         Set @ReturnMsg = '�õ��������';
                         GOTO SQLERR1;
                    End;
                End
            End
        IF @ProType <> '4'
            Begin
            -------------�������
                if(@billTemplateGuid='10051508008')
                Begin
                  UPDATE WMS_DownStrateGyDetail SET SELLOUTORDER = null WHERE MAINGUID=@BILLGUID;
                  BEGIN
                      UPDATE A SET A.SELLOUTORDER=B.SORTNUMBER  FROM WMS_DownStrateGyDetail A INNER JOIN WMS_GOODSPLACESORT B ON A.GOODSPLACEGUID = B.GOODSPLACEGUID WHERE B.BILLTEMPLATEGUID =@BILLTEMPLATEGUID AND B.Mainguid=@BILLGUID
                      IF @@ERROR <> 0
                      Begin
                          SET @ReturnMsg = '��λ��λ�������';
                          GOTO SQLERR1;
                      End
                  END;
                End;
            End
    COMMIT Tran ;
    set @RETURNMSG = ' ' ;
    set @RETURNVALUE = 0 ;
    Return ;
  SQLErr1:
    Rollback  transaction
    Set @ReturnValue = -1 ;
    Return;
END;
