select * from dw.callvolume



SELECT  Agent_id,  avg([Call_Seconds ]) as Call_Time_Duration FROM DW.callvolume
group by agent_id
order by 1




--Average call duration per time bucket 
SELECT  time_bucket,   avg([Call_Seconds ]) as Call_Time_Duration FROM DW.callvolume
where Call_Status='answered'
group by time_bucket
order by 1


--Calculate the average call time duration for all incoming calls received by agents (in each Time_Bucket).

select * from 
(
SELECT  Agent_id,  Time_Bucket, [Call_Seconds ] FROM DW.callvolume
WHERE Call_Status='answered'
) a 

PIVOT 
( AVG([Call_Seconds ]) for Time_Bucket IN ( [9-10] , [10-11], [11-12], [12-13],[13-14], [14-15],[15-16], [16-17] , 
[17-18], [18-19], [19-20], [20-21])
) p 
order by Agent_ID




--Show the total volume/ number of calls coming 


select  time_bucket , count(*) as call_volume ,
Round(cast(count(*)  as float ) / sum(count(*))   OVER (),3 ) as 'Percentage'   from dw.callvolume
group by Time_Bucket
order by 1 asc

-- Volume of Answered calls in percentage for each time bucket 

select a.Time_Bucket, call_answered,Total_callvolume,
round (cast(call_answered as float) /cast(Total_callvolume as float),3) as [% Answered_Callvolume] from 

( 
select time_bucket , COUNT(*) as call_answered from dw.callvolume
where Call_Status='Answered'
group by Time_Bucket
)a 
 JOIN
 ( SELECT Time_Bucket, COUNT(*) AS Total_callvolume FROM dw.callvolume
 group by Time_Bucket
 ) b 
 on a.Time_Bucket=b.Time_Bucket
 order by 1




