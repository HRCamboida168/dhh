USE [dhh_db]
GO
/****** Object:  StoredProcedure [dbo].[tdhh_invoice_payments_ins]    Script Date: 7/16/2020 1:59:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[tdhh_invoice_payments_ins]
			(@pmt_num   varchar(15)
           ,@inv_num   varchar(15)
           ,@cli_num   varchar(15)
           ,@pmt_dt   smalldatetime
           ,@strt_bal   numeric(18,2)
           ,@pmt_amt   numeric(18,2)
           ,@end_bal   numeric(18,2)
           ,@rec_status   char(1)
           ,@created_dt   smalldatetime
           ,@created_by   varchar(20))
as
BEGIN
	INSERT INTO dbo.tdhh_invoice_payments
			   (pmt_num
			   ,inv_num
			   ,cli_num
			   ,pmt_dt
			   ,strt_bal
			   ,pmt_amt
			   ,end_bal
			   ,rec_status
			   ,created_dt
			   ,created_by)
		 VALUES
			   (@pmt_num
			   ,@inv_num
			   ,@cli_num
			   ,@pmt_dt
			   ,@strt_bal
			   ,@pmt_amt
			   ,@end_bal
			   ,@rec_status
			   ,@created_dt
			   ,@created_by);

	UPDATE tdhh_invoice_masters 
	SET
		deposit_amt=deposit_amt + @pmt_amt
		,pening_amt = gros_amt - (deposit_amt + @pmt_amt)
		,inv_status = IIF(@end_bal<=0,'C','P')
	WHERE inv_num=@inv_num;
END;