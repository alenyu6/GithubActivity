package ecs189.querying.github;

import ecs189.querying.Util;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by Vincent on 10/1/2017.
 */
public class GithubQuerier {

    private static final String BASE_URL = "https://api.github.com/users/";
    private static final String ACCESS_TOKEN = "c40b08262ef6333fe52492c438180f82b1525885";

    public static String eventsAsHTML(String user) throws IOException, ParseException {
        List<JSONObject> response = getRecentPushEvents(user,10);
        StringBuilder sb = new StringBuilder();
        sb.append("<div>");
        for (int i = 0; i < response.size(); i++) {
            JSONObject event = response.get(i);
            sb.append( pushEventAsHtml(event, i) );
        }
        sb.append("</div>");
        return sb.toString();
    }

    private static String pushEventAsHtml(JSONObject pushEvent, int id) throws IOException, ParseException{

        //Parsing JSON
        StringBuilder sb = new StringBuilder();
        String type = pushEvent.getString("type");
        String creationDate = pushEvent.getString("created_at");
        SimpleDateFormat inFormat = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss'Z'");
        SimpleDateFormat outFormat = new SimpleDateFormat("dd MMM, yyyy");
        Date date = inFormat.parse(creationDate);
        String formatted = outFormat.format(date);

        JSONObject payload = pushEvent.getJSONObject("payload");
        String hash = payload.getString("head").substring(0,8);

        //Header
        sb.append("<h3>");
        sb.append(type);
        sb.append("</h3>");
        // Add formatted date
        sb.append("<div>");
        sb.append(hash);
        sb.append("</div>");

        sb.append("<div>");
        sb.append(" on ");
        sb.append(formatted);
        sb.append("</div>");

        System.out.println(sb.toString());

        //Content
        // Add collapsible JSON textbox (don't worry about this for the homework; it's just a nice CSS thing I like)
        sb.append("<a data-toggle=\"collapse\" href=\"#event-" + id + "\">JSON</a>");
        sb.append("<div id=event-" + id + " class=\"collapse\" style=\"height: auto;\"> <pre>");
        sb.append(pushEvent.toString());
        sb.append("</pre> </div>");

        return sb.toString();
    }

    private static List<JSONObject> paginatePushEvents(String user, int pageNumber) throws IOException {
        List<JSONObject> result = new ArrayList<JSONObject>();
        String eventUrl = BASE_URL + user + "/events";
        String paramQuery = "access_token=" + ACCESS_TOKEN + "&page=" + pageNumber;
        JSONObject json = Util.queryAPI(new URL(eventUrl + "?" + paramQuery));
        JSONArray response = json.getJSONArray("root");
        for(int i = 0; i < response.length(); i++){
            JSONObject obj = response.getJSONObject(i);
            if(obj.getString("type").equals("PushEvent")){
                result.add(obj);
            }
        }
        return result;
    }

    private static List<JSONObject> getRecentPushEvents(String user, int max) throws IOException {
        int page = 1;
        int eventCounter = 0;
        List<JSONObject> result = new ArrayList<JSONObject>();
        List<JSONObject> currEvents = paginatePushEvents(user, page);
        while(eventCounter <= max && !currEvents.isEmpty()){
            result.addAll(currEvents);
            currEvents = paginatePushEvents(user, ++page);
            eventCounter += currEvents.size();
        }
        return result.subList(0,max);
    }
}