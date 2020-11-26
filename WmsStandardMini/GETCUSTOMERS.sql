CREATE FUNCTION GETCUSTOMERS(@downstrategyguid varchar(50))
Returns Varchar(4000)
as
Begin
    DECLARE @value varchar(4000)
    SELECT @value = stuff((
                 SELECT ',' + B.MC
                   FROM (SELECT DISTINCT T2.MC FROM WMS_TASKGROUPDETAIL t INNER JOIN FAHUOHEAD t1 on t.FAHUOHEADGUID = t1.Guid INNER JOIN GL_CUSTOM t2 ON t1.CustomGuid = t2.TJBH WHERE t.TASKGROUPGUID = A.GUID) B
                FOR xml path('')) , 1 , 1 , '')
    FROM WMS_TASKGROUP A WHERE GUID = @downstrategyguid
    return @value
End