DECLARE

  start_date DATE      := TO_DATE('18.07.2010 11:46', 'DD.MM.YYYY HH24:MI');


  TYPE num_array IS TABLE OF NUMBER;--INDEX BY VARCHAR2(10);
  mi         num_array := num_array(0, 45);
  hh         num_array := num_array(11,12);
  dw         num_array := num_array(1, 2, 6);
  dd         num_array := num_array(3, 6, 14, 18, 21, 24, 28);
  --dd         num_array := num_array(29);
  mm         num_array := num_array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
  --mm         num_array := num_array(2);

  s_mi       NUMBER    := TO_CHAR(start_date, 'MI');
  s_hh       NUMBER    := TO_CHAR(start_date, 'HH24');
  s_dd       NUMBER    := TO_CHAR(start_date, 'DD');
  s_mm       NUMBER    := TO_CHAR(start_date, 'MM');
  s_yyyy     NUMBER    := TO_CHAR(start_date, 'YYYY');


  n_mi       NUMBER;
  n_hh       NUMBER;
  n_dd       NUMBER;
  n_mm       NUMBER;
  n_dw       NUMBER;
  new_date   DATE;

BEGIN

<< find_month >>

  FOR m IN 1 .. mm.COUNT
  LOOP

    IF s_mm <= mm(m)
    THEN

      n_mm := mm(m);
      EXIT;

    ELSE

      IF m = mm.COUNT
      THEN
        n_mm := mm(mm.FIRST);

        s_mi := mi(mi.FIRST);
        s_hh := hh(hh.FIRST);
        s_dd := dd(dd.FIRST);
        s_mm := mm(mm.FIRST);
        s_yyyy := s_yyyy + 1;

      END IF;
    END IF;

  END LOOP;

<< find_day >>

  FOR d IN 1 .. dd.COUNT
  LOOP

    IF s_dd <= dd(d)
    THEN

      n_dd := dd(d);
      EXIT;

    ELSE
      IF d = dd.COUNT
      THEN

        s_dd := dd(dd.FIRST);
        IF n_mm <> mm(mm.LAST)
        THEN
          s_mm := n_mm + 1;
        ELSE
          s_mm := mm(mm.FIRST);
          s_yyyy := s_yyyy + 1;
        END IF;

        s_mi := mi(mi.FIRST);
        s_hh := hh(hh.FIRST);
        s_dd := dd(dd.FIRST);

        GOTO find_month;
      END IF;
    END IF;
  END LOOP;

  BEGIN
    new_date := TO_DATE(TO_CHAR(n_dd) || '.' || TO_CHAR(n_mm) || '.' || TO_CHAR(s_yyyy), 'DD.MM.YYYY');

    n_dw := TO_NUMBER(TO_CHAR(new_date, 'D'));
    DBMS_OUTPUT.PUT_LINE('test date: ' || TO_CHAR(new_date, 'DD.MM.YYYY') || ' day of the week: ' || TO_CHAR(n_dw));

    FOR i IN 1 .. dw.COUNT
    LOOP
      IF n_dw = dw(i)
      THEN

        DBMS_OUTPUT.PUT_LINE('day of the week: ' || TO_CHAR(dw(i)));
        EXIT;

      ELSE
        IF i = dw.COUNT
        THEN
          IF n_dd <> dd(dd.LAST)
          THEN

            s_dd := n_dd + 1;
            s_mi := mi(mi.FIRST);
            s_hh := hh(hh.FIRST);

            GOTO find_day;
          ELSE

            IF n_mm <> mm(mm.LAST)
            THEN
              s_mm := n_mm + 1;
            ELSE
              s_mm := mm(mm.FIRST);
              s_yyyy := s_yyyy + 1;
            END IF;

            s_mi := mi(mi.FIRST);
            s_hh := hh(hh.FIRST);
            s_dd := dd(dd.FIRST);

            GOTO find_month;
          END IF;
        END IF;
      END IF;
    END LOOP;

  << find_hh >>

    FOR h IN 1 .. hh.COUNT
    LOOP
      IF s_hh <= hh(h)
      THEN

        n_hh := hh(h);

        EXIT;

      ELSE
        IF h = hh.COUNT
        THEN
          IF TRUNC(start_date, 'DD') = TRUNC(new_date, 'DD')
          THEN

            s_dd := n_dd + 1;

            s_mi := mi(mi.FIRST);
            s_hh := hh(hh.FIRST);

            GOTO find_day;
          END IF;
        END IF;
      END IF;
    END LOOP;

    new_date := TO_DATE(TO_CHAR(n_dd) || '.' || TO_CHAR(n_mm) || '.' || TO_CHAR(s_yyyy) || ' ' || TO_CHAR(n_hh) || ':00', 'DD.MM.YYYY HH24:MI');

    IF start_date <= new_date
    THEN
      s_mi := mi(mi.FIRST);
    END IF;

    FOR i IN 1 .. mi.COUNT
    LOOP
      IF s_mi <= mi(i)
      THEN

        n_mi := mi(i);
        EXIT;

      ELSE
        IF i = mi.COUNT
        THEN
          IF TRUNC(start_date, 'HH24') = TRUNC(new_date, 'HH24')
          THEN

            s_hh := n_hh + 1;
            s_mi := mi(mi.FIRST);

            GOTO find_hh;
          END IF;
        END IF;
      END IF;
    END LOOP;

    new_date := TO_DATE(TO_CHAR(n_dd) || '.' || TO_CHAR(n_mm) || '.' || TO_CHAR(s_yyyy) || ' ' || TO_CHAR(n_hh) || ':' || TO_CHAR(n_mi), 'DD.MM.YYYY HH24:MI');

  EXCEPTION
    WHEN OTHERS THEN BEGIN

          s_mm := n_mm + 1;
          GOTO find_month;

        END;
  END;

  DBMS_OUTPUT.PUT_LINE('result date: ' || TO_CHAR(new_date, 'DD.MM.YYYY HH24:MI'));
--SELECT 'result date: ' || TO_CHAR(new_date, 'DD.MM.YYYY HH24:MI') AS result_date FROM DUAL;

END;
