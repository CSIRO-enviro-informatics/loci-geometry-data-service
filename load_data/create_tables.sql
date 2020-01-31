drop materialized view combined_geoms;
create materialized view combined_geoms as (
	    select mb_code16 as id, geom_3577 as geom, 'asgs16_mb' as dataset from asgs16_mb
	       UNION
	    select sa1_main16 as id, geom_3577 as geom, 'asgs16_sa1' as dataset from asgs16_sa1
	       UNION
	    select sa2_main16 as id, geom_3577 as geom, 'asgs16_sa2' as dataset from asgs16_sa2
	       UNION
	    select sa3_code16 as id, geom_3577 as geom, 'asgs16_sa3' as dataset from asgs16_sa3
	       UNION
	    select sa4_code16 as id, geom_3577 as geom, 'asgs16_sa4' as dataset from asgs16_sa4
	       UNION
	    select ste_code16 as id, geom_3577 as geom, 'asgs16_ste' as dataset from asgs16_ste
	       UNION
	    select iar_code16 as id, geom_3577 as geom, 'asgs16_iare' as dataset from asgs16_iare
	       UNION
	    select ilo_code16 as id, geom_3577 as geom, 'asgs16_iloc' as dataset from asgs16_iloc
	       UNION
	    select ire_code16 as id, geom_3577 as geom, 'asgs16_ireg' as dataset from asgs16_ireg
	       UNION
	    select ra_code16 as id, geom_3577 as geom, 'asgs16_ra' as dataset from asgs16_ra
	       UNION
	    select ucl_code16 as id, geom_3577 as geom, 'asgs16_ucl' as dataset from asgs16_ucl
	       UNION
	    select ssr_code16 as id, geom_3577 as geom, 'asgs16_sosr' as dataset from asgs16_sosr
	       UNION
	    select sos_code16 as id, geom_3577 as geom, 'asgs16_sos' as dataset from asgs16_sos
	       UNION
	    select sua_code16 as id, geom_3577 as geom, 'asgs16_sua' as dataset from asgs16_sua
	       UNION
	    select cast(hydroid as varchar) as id, geom_3577 as geom, 'geofabric2_1_1_ahgfcontractedcatchment' as dataset from geofabric2_1_1_ahgfcontractedcatchment
	       UNION
	    select cast(hydroid as varchar) as id, geom_3577 as geom, 'geofabric2_1_1_riverregion' as dataset from geofabric2_1_1_riverregion
	       UNION
	    select cast(hydroid as varchar) as id, geom_3577 as geom, 'geofabric2_1_1_awradrainagedivision' as dataset from geofabric2_1_1_awradrainagedivision
);


CREATE INDEX gds_geom_idx ON combined_geoms_mat  USING GIST(geom);

drop table combined_geom_count;

CREATE TABLE combined_geom_count (
	    geom_total_count integer    
);
INSERT INTO combined_geom_count (geom_total_count) 
(SELECT count(*) FROM combined_geoms);


