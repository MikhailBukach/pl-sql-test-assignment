DECLARE
  --start_date DATE      := TO_DATE('03.04.2016 23:36', 'DD.MM.YYYY HH24:MI');
  start_date  DATE      := TO_DATE('19.07.2010 23:36', 'DD.MM.YYYY HH24:MI');


  TYPE num_array IS TABLE OF NUMBER;--INDEX BY VARCHAR2(10);
  mi          num_array := num_array(0, 45);
  hh          num_array := num_array(12);
  dw          num_array := num_array(1, 2, 6);
  dd          num_array := num_array(3, 6, 14, 18, 21, 24, 28);
  --    dd         num_array := num_array(29);
  mm          num_array := num_array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
  --     mm         num_array := num_array(2);

  s_dd        NUMBER    := TO_CHAR(start_date, 'DD');
  s_mm        NUMBER    := TO_CHAR(start_date, 'MM');
  s_yyyy      NUMBER    := TO_CHAR(start_date, 'YYYY');

  attempts_dd num_array := num_array();
  attempts_mm num_array := num_array();
  i_dd        NUMBER;
  n_dd        NUMBER;
  n_mm        NUMBER;
  n_dw        NUMBER;
  new_date    DATE;
BEGIN

--  FOR y IN s_yyyy .. s_yyyy
--  LOOP

<< find_month >>
  FOR m IN 1 .. mm.COUNT
  LOOP

    IF s_mm <= mm(m)
    THEN

      n_mm := mm(m);
      attempts_mm.EXTEND();
      attempts_mm(attempts_mm.COUNT) := m;
      EXIT;
    ELSE
      IF m = mm.COUNT
      THEN
        n_mm := mm(mm.FIRST);
        attempts_mm.EXTEND();
        attempts_mm(attempts_mm.COUNT) := m;
        s_yyyy := s_yyyy + 1;
      END IF;
    END IF;

  END LOOP;

  IF s_mm < n_mm
  THEN
    s_dd := dd(dd.FIRST);
  END IF;

<< find_day >>
  FOR d IN 1 .. dd.COUNT
  LOOP

    IF s_dd <= dd(d)
    THEN
      n_dd := dd(d);
      attempts_dd.EXTEND();
      attempts_dd(attempts_dd.COUNT) := d;
      EXIT;
    ELSE
      IF d = dd.COUNT
      THEN
        n_dd := dd(dd.FIRST);
        attempts_dd.EXTEND();
        attempts_dd(attempts_dd.COUNT) := d;
      END IF;
    END IF;
  END LOOP;

  BEGIN
    new_date := TO_DATE(TO_CHAR(n_dd) || '.' || TO_CHAR(n_mm) || '.' || TO_CHAR(s_yyyy), 'DD.MM.YYYY');
    DBMS_OUTPUT.PUT_LINE('attempt ' || TO_CHAR(new_date, 'DD.MM.YYYY'));
    n_dw := TO_NUMBER(TO_CHAR(new_date, 'D'));
    FOR i IN 1 .. dw.COUNT
    LOOP
      IF n_dw = dw(i)
      THEN
        EXIT;
      ELSE
        IF i = dw.COUNT
        THEN
          IF n_dd <> dd(dd.LAST)
          THEN
            s_dd := n_dd + 1;
            GOTO find_day;
          ELSE
            IF s_mm <> mm(mm.LAST)
            THEN
              s_mm := s_mm + 1;
            END IF;
            s_dd := dd(dd.FIRST);
            GOTO find_month;
          END IF;
        END IF;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN BEGIN
          --DBMS_OUTPUT.PUT_LINE(n_mm);
          GOTO find_month;
        END;
  END;
  --  END LOOP;
  DBMS_OUTPUT.PUT_LINE('result date: ' || TO_CHAR(new_date, 'DD.MM.YYYY'));

END;