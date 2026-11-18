-- Organisatie op de wachtrij, zodat support de eerste lijn van een ambassadeur ziet.
-- Eenmalig draaien in de Supabase SQL-editor.

create or replace function public.boa_wachtrij(p_lijn text)
returns jsonb
language plpgsql
volatile
security definer
set search_path = public
as $$
declare
  actor record;
begin
  perform public.boa_opschonen();
  select * into actor from public.boa_actor();
  if actor.user_id is null then
    raise exception 'Alleen voor behandelaars.';
  end if;
  return jsonb_build_object(
    'support', (select count(*) from public.boa_ticket t where t.lijn = 'support' and t.status <> 'Opgelost / Gesloten'),
    'beheer', (select count(*) from public.boa_ticket t where t.lijn = 'beheer' and t.status <> 'Opgelost / Gesloten'),
    'gesloten', (select count(*) from public.boa_ticket t where t.status = 'Opgelost / Gesloten'),
    'items', coalesce((
      select jsonb_agg(x) from (
        select jsonb_build_object(
          'nummer', t.nummer,
          'client_id', t.client_id,
          'pv_naam', t.pv_naam,
          'organisatie', t.organisatie,
          'categorie', t.categorie,
          'prioriteit', t.prioriteit,
          'status', t.status,
          'onderwerp', t.onderwerp,
          'lijn', t.lijn,
          'created_at', t.created_at
        ) as x
        from public.boa_ticket t
        where (p_lijn = 'support' and t.lijn = 'support' and t.status <> 'Opgelost / Gesloten')
           or (p_lijn = 'beheer' and t.lijn = 'beheer' and t.status <> 'Opgelost / Gesloten')
           or (p_lijn = 'gesloten' and t.status = 'Opgelost / Gesloten')
        order by case t.prioriteit when 'P1' then 1 when 'P2' then 2 when 'P3' then 3 else 4 end, t.created_at desc
        limit case when p_lijn = 'gesloten' then 40 else 200 end
      ) s
    ), '[]'::jsonb)
  );
end;
$$;
