truncate table ads${env}.ADS_HR_COST_PROFIT;

insert into
    ads${env}.ADS_HR_COST_PROFIT (
        `biz_year`,
        `org_name`,
        `total_cost`,
        `gross_profit`,
        `net_profit`,
        `gross_revenue`,
        `labor_cost`,
        `wages`,
        `employees`,
        `mean_wage`,
        `productivity`,
        `labor_cost_ratio`,
        `bench_p50`,
        `bench_quantile`,
        `profit_margin`,
        `labor_percentage`,
        `org_code`,
        `biz_date`
    )
with
    clear as (
        select
            *,
            zgrs_e as 职工人数,
            zgpjrs_k as 职工平均人数, -- = 职工人数
            CYRYPJRS_C as 从业人员平均人数,
            cast(
                aes_decrypt (
                    unhex (yyzcb_z),
                    'F3M0PxSWod6cyCejYUkpccU9gMsWwgrM'
                ) as double
            ) as 营业总成本,
            cast(
                aes_decrypt (
                    unhex (lrze_f),
                    'F3M0PxSWod6cyCejYUkpccU9gMsWwgrM'
                ) as double
            ) as 利润总额,
            cast(
                aes_decrypt (unhex (jlr_u), 'F3M0PxSWod6cyCejYUkpccU9gMsWwgrM') as double
            ) as 净利润,
            cast(
                aes_decrypt (
                    unhex (yyzsr_e),
                    'F3M0PxSWod6cyCejYUkpccU9gMsWwgrM'
                ) as double
            ) as 营业总收入,
            cast(
                aes_decrypt (
                    unhex (qyrgcb_k),
                    'F3M0PxSWod6cyCejYUkpccU9gMsWwgrM'
                ) as double
            ) as 企业人工成本,
            cast(
                aes_decrypt (
                    unhex (sfzggzze_x),
                    'F3M0PxSWod6cyCejYUkpccU9gMsWwgrM'
                ) as double
            ) as 实发职工工资总额,
            cast(
                aes_decrypt (
                    unhex (ldsczz_e),
                    'F3M0PxSWod6cyCejYUkpccU9gMsWwgrM'
                ) as double
            ) as 劳动生产总值,
            cast(
                aes_decrypt (
                    unhex (ZGRGCB_S),
                    'F3M0PxSWod6cyCejYUkpccU9gMsWwgrM'
                ) as double
            ) as 职工人工成本
        from
            ods${env}.ODS_HR_XYYRGCBQK
    )
select
    nd_s as biz_year,
    coalesce(zgqy_t, '') as org_name,
    营业总成本 as total_cost,
    利润总额 as gross_profit,
    净利润 as net_profit,
    营业总收入 as gross_revenue,
    企业人工成本 as labor_cost,
    实发职工工资总额 as wages,
    职工人数 as employees,
    实发职工工资总额 / 职工平均人数 as mean_wage, -- 平均工资
    劳动生产总值 / 从业人员平均人数 as productivity, -- 全员劳动生产率
    100 * 职工人工成本 / 营业总收入 as labor_cost_ratio, -- 人事费用率
    null as bench_p50,
    null as bench_quantile,
    100 * 利润总额 / 职工人工成本 as profit_margin, -- 人工成本利润率
    100 * 职工人工成本 / 营业总成本 as labor_percentage, -- 人工成本占总成本比例
    zzdm_j as org_code,
    null as biz_date
from
    clear