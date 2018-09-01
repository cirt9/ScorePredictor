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

    return first();
}

bool Query::isUserRegistered(const QString & nickname)
{
    prepare("SELECT 1 FROM user WHERE nickname=:nickname");
    bindValue(":nickname", nickname);
    exec();

    return first();
}

bool Query::registerUser(const QString & nickname, const QString & password)
{
    prepare("INSERT INTO user(nickname, password) VALUES (:nickname, :password)");
    bindValue(":nickname", nickname);
    bindValue(":password", password);
    exec();

    return numRowsAffected() > 0 ? true : false;
}

bool Query::isPasswordCorrect(const QString & nickname, const QString & password)
{
    prepare("SELECT 1 FROM user WHERE nickname=:nickname AND password=:password");
    bindValue(":nickname", nickname);
    bindValue(":password", password);
    exec();

    return first();
}

bool Query::getUserInfo(const QString & nickname)
{
    prepare("SELECT description, avatar_path FROM user "
            "INNER JOIN user_profile on user.id = user_profile.user_id "
            "WHERE user.nickname=:nickname");
    bindValue(":nickname", nickname);
    exec();

    return first();
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

bool Query::updateUserProfileDescription(unsigned int userId, const QString & description)
{
    prepare("UPDATE user_profile SET description = :description WHERE user_id = :userId");
    bindValue(":description", description);
    bindValue(":userId", userId);
    exec();

    return numRowsAffected() > 0 ? true : false;
}

bool Query::findUserProfileAvatarPath(unsigned int userId)
{
    prepare("SELECT avatar_path FROM user_profile WHERE user_id = :userId");
    bindValue(":userId", userId);
    exec();

    return first();
}

bool Query::updateUserProfileAvatarPath(unsigned int userId, const QString & avatarPath)
{
    prepare("UPDATE user_profile SET avatar_path = :avatarPath WHERE user_id = :userId");
    bindValue(":avatarPath", avatarPath);
    bindValue(":userId", userId);
    exec();

    return numRowsAffected() > 0 ? true : false;
}

bool Query::tournamentExists(const QString & tournamentName, unsigned int hostId)
{
    prepare("SELECT 1 FROM tournament WHERE name=:tournamentName AND host_user_id=:hostId");
    bindValue(":tournamentName", tournamentName);
    bindValue(":hostId", hostId);
    exec();

    return first();
}

bool Query::createTournament(const Tournament & tournament, unsigned int hostId, const QString & password)
{
    prepare("INSERT INTO tournament (name, host_user_id, password, entries_end_time, predictors_limit, opened) "
                  "VALUES (:tournamentName, :hostId, :password, :entriesEndTime, :predictorsLimit, :opened)");
    bindValue(":tournamentName", tournament.getName());
    bindValue(":hostId", hostId);
    bindValue(":password", password);
    bindValue(":entriesEndTime", tournament.getEntriesEndTime());
    bindValue(":predictorsLimit", tournament.getPredictorsLimit());
    bindValue(":opened", true);
    exec();

    return numRowsAffected() > 0 ? true : false;
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
            "WHERE t.id = tournament.id) as 'predictors', "
            "predictors_limit FROM tournament "
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

    return first();
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

    return first();
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

bool Query::tournamentIsFull(unsigned int tournamentId)
{
    prepare("SELECT CASE WHEN (SELECT count(id) FROM tournament_participant WHERE "
            "tournament_id = :tournamentId) < predictors_limit THEN 0 ELSE 1 END as is_full "
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

    return numRowsAffected() > 0 ? true : false;
}

void Query::findTournamentInfo(unsigned int tournamentId)
{
    prepare("SELECT (SELECT CASE WHEN length(password) > 0 THEN 1 ELSE 0 END "
            "FROM tournament WHERE id = :tournamentId) AS password_required, entries_end_time, "
            "(SELECT count(id) FROM tournament_participant WHERE tournament_id = :tournamentId) "
            "AS predictors, predictors_limit, opened FROM tournament "
            "INNER JOIN user ON tournament.host_user_id = user.id "
            "WHERE tournament.id = :tournamentId");
    bindValue(":tournamentId", tournamentId);
    exec();
}

void Query::findTournamentRounds(unsigned int tournamentId)
{
    prepare("SELECT name FROM round WHERE tournament_id = :tournamentId "
            "ORDER BY number");
    bindValue(":tournamentId", tournamentId);
    exec();
}

bool Query::allMatchesFinished(unsigned int tournamentId)
{
    prepare("SELECT CASE WHEN datetime( (SELECT predictions_end_time FROM match "
            "INNER JOIN round ON round.id = match.round_id INNER JOIN tournament "
            "ON tournament.id = round.tournament_id WHERE tournament_id = :tournamentId "
            "ORDER BY predictions_end_time DESC LIMIT 1) ) >= datetime('now', 'localtime') "
            "THEN 0 ELSE 1 END AS all_matches_finished");
    bindValue(":tournamentId", tournamentId);
    exec();
    next();

    return value("all_matches_finished").toBool();
}

bool Query::finishTournament(unsigned int tournamentId)
{
    prepare("UPDATE tournament SET opened = 0 WHERE id = :tournamentId");
    bindValue(":tournamentId", tournamentId);
    exec();

    return numRowsAffected() > 0 ? true : false;
}

bool Query::duplicateNameOfRound(const QString & roundName, unsigned int tournamentId)
{
    prepare("SELECT 1 FROM round WHERE name = :roundName AND tournament_id = :tournamentId");
    bindValue(":roundName", roundName);
    bindValue(":tournamentId", tournamentId);
    exec();

    return first();
}

bool Query::addNewRound(const QString & roundName, unsigned int tournamentId)
{
    prepare("INSERT INTO round (tournament_id, name, number) VALUES (:tournamentId, :roundName, "
            "(SELECT CASE WHEN (SELECT count(id) FROM round WHERE tournament_id = :tournamentId) = 0 THEN 1 "
            "ELSE (SELECT MAX(number) + 1 FROM round WHERE tournament_id = :tournamentId) END))");
    bindValue(":roundName", roundName);
    bindValue(":tournamentId", tournamentId);
    exec();

    return numRowsAffected() > 0 ? true : false;
}

void Query::findTournamentLeaderboard(unsigned int tournamentId)
{
    prepare("SELECT nickname, exact_score, predicted_result, (exact_score * 3 + predicted_result - exact_score) "
            "AS points FROM (SELECT DISTINCT user.nickname, (SELECT count(match_prediction.id) FROM match_prediction "
            "INNER JOIN match ON match.id = match_prediction.match_id INNER JOIN tournament_participant ON "
            "tournament_participant.id = match_prediction.tournament_participant_id INNER JOIN user u ON "
            "u.id = tournament_participant.user_id WHERE tournament_participant.tournament_id = :tournamentId "
            "AND u.id = user.id AND datetime(match.predictions_end_time) <= datetime('now', 'localtime') "
            "AND (match_prediction.competitor_1_score_prediction = match.competitor_1_score AND "
            "match_prediction.competitor_2_score_prediction = match.competitor_2_score) ) AS exact_score, "
            "(SELECT count(match_prediction.id) FROM match_prediction INNER JOIN match ON "
            "match.id = match_prediction.match_id INNER JOIN tournament_participant ON "
            "tournament_participant.id = match_prediction.tournament_participant_id INNER JOIN user u ON "
            "u.id = tournament_participant.user_id WHERE tournament_participant.tournament_id = :tournamentId "
            "AND u.id = user.id AND datetime(match.predictions_end_time) <= datetime('now', 'localtime') AND "
            "( (match.competitor_1_score > match.competitor_2_score AND "
            "match_prediction.competitor_1_score_prediction > match_prediction.competitor_2_score_prediction) OR "
            "(match.competitor_1_score < match.competitor_2_score AND "
            "match_prediction.competitor_1_score_prediction < match_prediction.competitor_2_score_prediction) OR "
            "(match.competitor_1_score = match.competitor_2_score AND "
            "match_prediction.competitor_1_score_prediction = match_prediction.competitor_2_score_prediction) ) ) "
            "AS predicted_result FROM user INNER JOIN tournament_participant ON "
            "tournament_participant.user_id = user.id WHERE tournament_participant.tournament_id = :tournamentId) "
            "ORDER BY points DESC, exact_score DESC, predicted_result DESC, nickname DESC");
    bindValue(":tournamentId", tournamentId);
    exec();
}

bool Query::findRoundId(const QString & roundName, unsigned int tournamentId)
{
    prepare("SELECT id FROM round WHERE name = :roundName AND tournament_id = :tournamentId");
    bindValue(":roundName", roundName);
    bindValue(":tournamentId", tournamentId);
    exec();

    return first();
}

void Query::findRoundLeaderboard(unsigned int tournamentId, unsigned int roundId)
{
    prepare("SELECT nickname, exact_score, predicted_result, (exact_score * 3 + predicted_result - exact_score) "
            "AS points FROM ( SELECT DISTINCT user.nickname, (SELECT count(match_prediction.id) FROM match_prediction "
            "INNER JOIN match ON match.id = match_prediction.match_id INNER JOIN round ON round.id = match.round_id "
            "INNER JOIN tournament_participant ON tournament_participant.id = match_prediction.tournament_participant_id "
            "INNER JOIN user u ON u.id = tournament_participant.user_id WHERE round.id = :roundId1 AND u.id = user.id "
            "AND datetime(match.predictions_end_time) <= datetime('now', 'localtime') AND "
            "(match_prediction.competitor_1_score_prediction = match.competitor_1_score AND "
            "match_prediction.competitor_2_score_prediction = match.competitor_2_score) ) AS exact_score, "
            "(SELECT count(match_prediction.id) FROM match_prediction INNER JOIN match ON "
            "match.id = match_prediction.match_id INNER JOIN round ON round.id = match.round_id INNER JOIN "
            "tournament_participant ON tournament_participant.id = match_prediction.tournament_participant_id INNER JOIN "
            "user u ON u.id = tournament_participant.user_id WHERE round.id = :roundId2 AND u.id = user.id AND "
            "datetime(match.predictions_end_time) <= datetime('now', 'localtime') AND "
            "( (match.competitor_1_score > match.competitor_2_score AND "
            "match_prediction.competitor_1_score_prediction > match_prediction.competitor_2_score_prediction) OR "
            "(match.competitor_1_score < match.competitor_2_score AND "
            "match_prediction.competitor_1_score_prediction < match_prediction.competitor_2_score_prediction) OR "
            "(match.competitor_1_score = match.competitor_2_score AND "
            "match_prediction.competitor_1_score_prediction = match_prediction.competitor_2_score_prediction) )) "
            "AS predicted_result FROM user INNER JOIN tournament_participant ON "
            "tournament_participant.user_id = user.id WHERE tournament_participant.tournament_id = :tournamentId) "
            "ORDER BY points DESC, exact_score DESC, predicted_result DESC, nickname DESC");
    bindValue(":tournamentId", tournamentId);
    bindValue(":roundId1", roundId);
    bindValue(":roundId2", roundId);
    exec();
}

bool Query::matchStartsAfterEntriesEndTime(unsigned int tournamentId, const QDateTime & predictionsEndTime)
{
    prepare("SELECT CASE WHEN datetime(:predictionsEndTime) >= datetime(entries_end_time) THEN 1 ELSE 0 END AS "
            "match_starts_after_entries_end_time FROM tournament WHERE id = :tournamentId");
    bindValue(":tournamentId", tournamentId);
    bindValue(":predictionsEndTime", predictionsEndTime);
    exec();
    next();

    return value("match_starts_after_entries_end_time").toBool();
}

void Query::findMatches(unsigned int roundId)
{
    prepare("SELECT competitor_1, competitor_1_score, competitor_2, competitor_2_score, "
            "predictions_end_time FROM match WHERE round_id = :roundId ORDER BY predictions_end_time");
    bindValue(":roundId", roundId);
    exec();
}

bool Query::duplicateMatch(const QString & firstCompetitor, const QString & secondCompetitor, unsigned int roundId)
{
    prepare("SELECT 1 FROM match WHERE competitor_1 = :firstCompetitor AND competitor_2 = :secondCompetitor "
            "AND round_id = :roundId");
    bindValue(":firstCompetitor", firstCompetitor);
    bindValue(":secondCompetitor", secondCompetitor);
    bindValue(":roundId", roundId);
    exec();

    return first();
}

bool Query::findMatchId(const QString & firstCompetitor, const QString & secondCompetitor, unsigned int roundId)
{
    prepare("SELECT id FROM match WHERE competitor_1 = :firstCompetitor "
            "AND competitor_2 = :secondCompetitor AND round_id = :roundId");
    bindValue(":firstCompetitor", firstCompetitor);
    bindValue(":secondCompetitor", secondCompetitor);
    bindValue(":roundId", roundId);
    exec();

    return first();
}

bool Query::createMatch(unsigned int roundId, const QString & firstCompetitor, const QString & secondCompetitor,
                        const QDateTime & predictionsEndTime)
{
    prepare("INSERT INTO match (round_id, competitor_1, competitor_2, predictions_end_time) "
            "VALUES (:roundId, :firstCompetitor, :secondCompetitor, :predictionsEndTime)");
    bindValue(":roundId", roundId);
    bindValue(":firstCompetitor", firstCompetitor);
    bindValue(":secondCompetitor", secondCompetitor);
    bindValue(":predictionsEndTime", predictionsEndTime);
    exec();

    return numRowsAffected() > 0 ? true : false;
}

bool Query::deleteMatch(unsigned int roundId, const QString & firstCompetitor, const QString & secondCompetitor)
{
    prepare("DELETE FROM match WHERE round_id = :roundId AND competitor_1 = :firstCompetitor AND "
            "competitor_2 = :secondCompetitor");
    bindValue(":roundId", roundId);
    bindValue(":firstCompetitor", firstCompetitor);
    bindValue(":secondCompetitor", secondCompetitor);
    exec();

    return numRowsAffected() > 0 ? true : false;
}

bool Query::updateMatchScore(unsigned int matchId, unsigned int firstCompetitorScore, unsigned int secondCompetitorScore)
{
    prepare("UPDATE match SET competitor_1_score = :firstCompetitorScore, "
            "competitor_2_score = :secondCompetitorScore WHERE id = :matchId");
    bindValue(":firstCompetitorScore", firstCompetitorScore);
    bindValue(":secondCompetitorScore", secondCompetitorScore);
    bindValue(":matchId", matchId);
    exec();

    return numRowsAffected() > 0 ? true : false;
}

void Query::findMatchesPredictions(unsigned int tournamentId, unsigned int roundId, unsigned int requesterId)
{
    prepare("SELECT nickname, competitor_1_score_prediction, competitor_2_score_prediction, "
            "competitor_1, competitor_2 FROM match_prediction INNER JOIN tournament_participant ON "
            "match_prediction.tournament_participant_id = tournament_participant.id "
            "INNER JOIN user ON tournament_participant.user_id = user.id "
            "INNER JOIN match ON match_prediction.match_id = match.id "
            "WHERE tournament_participant.tournament_id = :tournamentId AND match.round_id = :roundId "
            "AND (datetime('now', 'localtime') >= datetime(predictions_end_time) OR user_id = :requesterId) "
            "ORDER BY predictions_end_time");
    bindValue(":tournamentId", tournamentId);
    bindValue(":roundId", roundId);
    bindValue(":requesterId", requesterId);
    exec();
}

bool Query::findTournamentParticipantId(unsigned int userId, unsigned int tournamentId)
{
    prepare("SELECT id FROM tournament_participant WHERE user_id = :userId AND tournament_id = :tournamentId");
    bindValue(":userId", userId);
    bindValue(":tournamentId", tournamentId);
    exec();

    return first();
}

bool Query::matchPredictionAlreadyExists(unsigned int matchId, unsigned int participantId)
{
    prepare("SELECT 1 FROM match_prediction WHERE match_id = :matchId AND tournament_participant_id = :participantId");
    bindValue(":matchId", matchId);
    bindValue(":participantId", participantId);
    exec();

    return first();
}

bool Query::matchAcceptsPredictions(unsigned int matchId)
{
    prepare("SELECT CASE WHEN datetime(predictions_end_time) > datetime('now', 'localtime') THEN 1 ELSE 0 END "
            "AS accepting_predictions FROM match WHERE id = :matchId");
    bindValue(":matchId", matchId);
    exec();
    next();

    return value("accepting_predictions").toBool();
}

bool Query::createMatchPrediction(unsigned int matchId, unsigned int participantId,
                                  unsigned int firstCompetitorScore, unsigned int secondCompetitorScore)
{
    prepare("INSERT INTO match_prediction (match_id, tournament_participant_id, competitor_1_score_prediction, "
            "competitor_2_score_prediction) VALUES (:matchId, :participantId, :firstCompetitorScore, "
            ":secondCompetitorScore)");
    bindValue(":matchId", matchId);
    bindValue(":participantId", participantId);
    bindValue(":firstCompetitorScore", firstCompetitorScore);
    bindValue(":secondCompetitorScore", secondCompetitorScore);
    exec();

    return numRowsAffected() > 0 ? true : false;
}

bool Query::updateMatchPrediction(unsigned int matchId, unsigned int participantId,
                                  unsigned int firstCompetitorScore, unsigned int secondCompetitorScore)
{
    prepare("UPDATE match_prediction SET competitor_1_score_prediction = :firstCompetitorScore, "
            "competitor_2_score_prediction = :secondCompetitorScore "
            "WHERE tournament_participant_id = :participantId AND match_id = :matchId");
    bindValue(":matchId", matchId);
    bindValue(":participantId", participantId);
    bindValue(":firstCompetitorScore", firstCompetitorScore);
    bindValue(":secondCompetitorScore", secondCompetitorScore);
    exec();

    return numRowsAffected() > 0 ? true : false;
}
