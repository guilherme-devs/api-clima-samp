#include <a_samp>
#include <a_http>
#include <zcmd>
#include <sscanf2> 

#define API_URL         "localhost:3000/weather-sync"
#define SYNC_INTERVAL   600000 // 10 minutos (em milisegundos)
new bool:ClimaBloqueado = false
forward SyncRealWeather();
forward OnWeatherUpdate(index, response_code, data[]);
forward OnWeatherUpdateManual(playerid, response_code, data[]);

public OnFilterScriptInit()
{
    print("------------------------------------------");
    print(" API Clima Real by Joseph as Load ");
    print("------------------------------------------");
    
    SetTimer("SyncRealWeather", SYNC_INTERVAL, true);
    return 1;
}

public OnFilterScriptExit()
{
    return 1;
}


public SyncRealWeather()
{
    HTTP(0, HTTP_GET, API_URL, "", "OnWeatherUpdate");
}

CMD:sincronizartempo(playerid, params[])
{
    // Verificação de Admin (Ajuste conforme sua GM)
    if(!IsPlayerAdmin(playerid)) 
        return SendClientMessage(playerid, -1, "{FF0000}Erro: {FFFFFF}Você não tem permissão.");

    SendClientMessage(playerid, -1, "{FF9900}<!>{ffffff} Solicitando atualização climática de SP...");
    
    HTTP(playerid, HTTP_GET, API_URL, "", "OnWeatherUpdateManual");
    return 1;
}

CMD:bloquearclima(playerid, params[])
{
    if(!IsPlayerAdmin(playerid)) 
        return SendClientMessage(playerid, -1, "{FF0000}Erro: {FFFFFF}Você não tem permissão.");

    ClimaBloqueado = !ClimaBloqueado; 
    
    new msg[128];
    format(msg, sizeof(msg), "{FFFF00}[CLIMA]: {FFFFFF}A sincronização automática está agora: %s", ClimaBloqueado ? ("{FF0000}BLOQUEADA") : ("{00FF00}LIBERADA"));
    SendClientMessage(playerid, -1, msg);
    
    printf("[LOG] Admin %d alterou a trava do clima para: %d", playerid, ClimaBloqueado);
    return 1;
}
public OnWeatherUpdate(index, response_code, data[])
{
    if(response_code == 200)
    {
        if(ClimaBloqueado) return 1;

        new wID, hh, mm;
        if(!sscanf(data, "p<,>iii", wID, hh, mm)) 
        {
            // Otimização Mobile: Se for chuva (8) ou tempestade (16), seta nublado (7) - [Joseph Dyer in 09/02/2026 as updated this line]
            if(wID == 8 || wID == 16) wID = 7;

            SetWeather(wID);
            SetWorldTime(hh);
            printf("[API Clima] Sincronização Automática: ID %d | Hora: %02d:%02d", wID, hh, mm);
        }
    }
    else printf("[API Clima] Erro na conexão: Código %d", response_code);
    return 1;
}

public OnWeatherUpdateManual(playerid, response_code, data[])
{
    if(response_code == 200)
    {
        if(ClimaBloqueado)
            return SendClientMessage(playerid, -1, "{FF0000}Erro: {FFFFFF}A sincronização está bloqueada no momento.");

        new wID, hh, mm;
        
        if(!sscanf(data, "p<,>iii", wID, hh, mm))
        {
            if(wID == 8 || wID == 16) wID = 7;

            SetWeather(wID);
            SetWorldTime(hh);
            
            new msg[128];
            format(msg, sizeof(msg), "{00FF00}[SUCESSO]: {FFFFFF}Clima de SP aplicado (ID: %d | Hora: %02d:%02d)", wID, hh, mm);
            SendClientMessage(playerid, -1, msg);
        }
    }
    else SendClientMessage(playerid, -1, "{FF0000}Erro: {FFFFFF}Não foi possível conectar à API de clima.");
    return 1;
}
