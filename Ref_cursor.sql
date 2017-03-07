TYPE building_curtype IS REF CURSOR;
Create the procedure. Notice that the mode of the cursor variable parameter is IN OUT:

PROCEDURE open_site_list
   (address_in IN VARCHAR2,
    site_cur_inout IN OUT building_curtype)
IS
   home_type CONSTANT INTEGER := 1;
   commercial_type CONSTANT INTEGER := 2;

   /* A static cursor to get building type. */
   CURSOR site_type_cur IS
      SELECT site_type FROM property_master
       WHERE address = address_in;
   site_type_rec site_type_cur%ROWTYPE;

BEGIN
   /* Get the building type for this address. */
   OPEN site_type_cur;
   FETCH site_type_cur INTO site_type_rec;
   CLOSE site_type_cur;

   /* Now use the site type to select from the right table.*/
   IF site_type_rec.site_type =  home_type
   THEN
      /* Use the home properties table. */
      OPEN site_cur_inout FOR
         SELECT * FROM home_properties
          WHERE address LIKE '%' || address_in || '%';

   ELSIF site_type_rec.site_type =  commercial_type
   THEN
      /* Use the commercial properties table. */
      OPEN site_cur_inout FOR
         SELECT * FROM commercial_properties
          WHERE address LIKE '%' || address_in || '%';
   END IF;
END open_site_list;