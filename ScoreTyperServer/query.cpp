#include "query.h"

Query::Query(const QSqlDatabase & dbConnection) : QSqlQuery(dbConnection)
{
    setForwardOnly(true);
}

bool Query::findUserId(const QString & nickname)
{
    prepare("SELECT id FROM user WHERE nickname=:nickname");
    bindValue(":nickname", nickname);
    exec();

    if(first())
        return true;
    else
        return false;
}

bool Query::isUserRegistered(const QString & nickname)
{
    prepare("SELECT 1 FROM user WHERE nickname=:nickname");
    bindValue(":nickname", nickname);
    exec();

    if(first())
        return true;
    else
        return false;
}

bool Query::registerUser(const QString & nickname, const QString & password)
{
    prepare("INSERT INTO user(nickname, password) VALUES (:nickname, :password)");
    bindValue(":nickname", nickname);
    bindValue(":password", password);
    exec();

    if(numRowsAffected() > 0)
        return true;
    else
        return false;
}

bool Query::isPasswordCorrect(const QString & nickname, const QString & password)
{
    prepare("SELECT 1 FROM user WHERE nickname=:nickname AND password=:password");
    bindValue(":nickname", nickname);
    bindValue(":password", password);
    exec();

    if(first())
        return true;
    else
        return false;
}

bool Query::getUserInfo(const QString & nickname)
{
    prepare("SELECT description FROM user "
            "INNER JOIN user_profile on user.id = user_profile.user_id "
            "WHERE user.nickname=:nickname");
    bindValue(":nickname", nickname);
    exec();

    if(first())
        return true;
    else
        return false;
}

void Query::findUserTournaments(unsigned int userId, bool opened)
{
    prepare("SELECT tournament.name, user.nickname AS host_name FROM tournament "
            "INNER JOIN user ON tournament.host_user_id = user.id "
            "WHERE tournament.opened = :opened AND tournament.id IN "
            "(SELECT tournament_id FROM tournament_participant WHERE user_id = :userId) "
            "ORDER BY entries_end_time desc ");
    bindValue(":userId", userId);
    bindValue(":opened", opened);
    exec();
}

bool Query::tournamentExists(const QString & tournamentName, unsigned int hostId)
{
    prepare("SELECT 1 FROM tournament WHERE name=:tournamentName AND host_user_id=:hostId");
    bindValue(":tournamentName", tournamentName);
    bindValue(":hostId", hostId);
    exec();

    if(first())
        return true;
    else
        return false;
}

bool Query::createTournament(const Tournament & tournament, unsigned int hostId, const QString & password)
{
    prepare("INSERT INTO tournament (name, host_user_id, password, entries_end_time, typers_limit, opened) "
                  "VALUES (:tournamentName, :hostId, :password, :entriesEndTime, :typersLimit, :opened)");
    bindValue(":tournamentName", tournament.getName());
    bindValue(":hostId", hostId);
    bindValue(":password", password);
    bindValue(":entriesEndTime", tournament.getEntriesEndTime());
    bindValue(":typersLimit", tournament.getTypersLimit());
    bindValue(":opened", true);
    exec();

    if(numRowsAffected() > 0)
        return true;
    else
        return false;
}

void Query::findTournaments(unsigned int hostId, const QDateTime & dateTime, int itemsLimit, const QString & tournamentName)
{
    QString tournamentNamePattern;

    if(tournamentName.size() == 0)
        tournamentNamePattern = "%";
    else
        tournamentNamePattern = QString("%" + tournamentName + "%").replace(' ', '%');

    prepare("SELECT name, nickname as host_name, "
            "(SELECT CASE WHEN length(tournament.password) = 0 THEN 0 ELSE 1 END) AS password_required, "
            "entries_end_time, "
            "(SELECT count(tournament_participant.id) FROM tournament_participant "
            "INNER JOIN tournament AS t ON tournament_participant.tournament_id = tournament.id "
            "WHERE t.id = tournament.id) as 'typers', "
            "typers_limit FROM tournament "
            "INNER JOIN user ON host_user_id = user.id "
            "WHERE entries_end_time > :minDateTime AND tournament.id IN "
            "(SELECT tournament_id FROM tournament_participant WHERE tournament_id NOT IN "
            "(SELECT tournament_id FROM tournament_participant WHERE user_id = :hostId) "
            "GROUP BY tournament_id) AND tournament.name LIKE :tournamentNamePattern "
            "ORDER BY entries_end_time "
            "LIMIT :itemsLimit");
    bindValue(":hostId", hostId);
    bindValue(":minDateTime", dateTime);
    bindValue(":itemsLimit", itemsLimit);
    bindValue(":tournamentNamePattern", tournamentNamePattern);
    exec();
}

bool Query::findTournamentId(const QString & tournamentName, unsigned int hostId)
{
    prepare("SELECT id FROM tournament WHERE name = :tournamentName AND host_user_id = :hostId");
    bindValue(":tournamentName", tournamentName);
    bindValue(":hostId", hostId);
    exec();

    if(first())
        return true;
    else
        return false;
}

bool Query::tournamentIsOpened(unsigned int tournamentId)
{
    prepare("SELECT opened FROM tournament WHERE id = :tournamentId");
    bindValue(":tournamentId", tournamentId);
    exec();
    next();

    return value("opened").toBool();
}

bool Query::tournamentEntriesExpired(unsigned int tournamentId)
{
    prepare("SELECT CASE WHEN datetime(entries_end_time) <= datetime('now', 'localtime') "
            "THEN 1 ELSE 0 END as expired FROM tournament WHERE id = :tournamentId");
    bindValue(":tournamentId", tournamentId);
    exec();
    next();

    return value("expired").toBool();
}

bool Query::userPatricipatesInTournament(unsigned int tournamentId, unsigned int userId)
{
    prepare("SELECT 1 FROM tournament_participant "
            "WHERE tournament_id = :tournamentId AND user_id = :userId");
    bindValue(":tournamentId", tournamentId);
    bindValue(":userId", userId);
    exec();

    if(first())
        return true;
    else
        return false;
}

bool Query::tournamentRequiresPassword(unsigned int tournamentId)
{
    prepare("SELECT (SELECT CASE WHEN length(tournament.password) = 0 THEN 0 ELSE 1 END) "
            "AS password_required FROM tournament WHERE id = :tournamentId");
    bindValue(":tournamentId", tournamentId);
    exec();
    next();

    return value("password_required").toBool();
}

bool Query::tournamentIsFull(unsigned int tournamentId)
{
    prepare("SELECT CASE WHEN (SELECT count(id) FROM tournament_participant WHERE "
            "tournament_id = :tournamentId) < typers_limit THEN 0 ELSE 1 END as is_full "
            "FROM tournament WHERE id = :tournamentId");
    bindValue(":tournamentId", tournamentId);
    exec();
    next();

    return value("is_full").toBool();
}

bool Query::addUserToTournament(unsigned int tournamentId, unsigned int userId)
{
    prepare("INSERT INTO tournament_participant (tournament_id, user_id) "
            "VALUES (:tournamentId, :userId)");

    bindValue(":tournamentId", tournamentId);
    bindValue(":userId", userId);
    exec();

    if(numRowsAffected() > 0)
        return true;
    else
        return false;
}

bool Query::tournamentPasswordIsCorrect(unsigned int tournamentId, const QString & password)
{
    prepare("SELECT CASE WHEN password = :password THEN 1 ELSE 0 END as password_ok FROM tournament "
            "WHERE id = :tournamentId");
    bindValue(":tournamentId", tournamentId);
    bindValue(":password", password);
    exec();
    next();

    return value("password_ok").toBool();
}
