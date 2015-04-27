<cfoutput>	
<cfif not(isDefined("doSubmit"))>
	<cfparam name="txtRoot" default="">
	<cfparam name="txtStart" default="">
	<cfparam name="txtLevels" default="">
	<cfif isDefined("chkCF8Mode")>
		<cfset componentType = "_sitemap">
	<cfelse>
		<cfset cf7Timer = GetTickCount()>
		<cfset componentType = "_sitemapCF7">
	</cfif>
	<cfif txtRoot EQ "" OR txtStart EQ "" OR txtLevels EQ "">
		<cfset errorMsg = "Error none of the fields can be left blank.">
		<cflocation addtoken="No" url="index.cfm?errorMsg=#ErrorMsg#">
	<cfelseif Right(txtPhysicalPath,3) NEQ "xml">
		<cfset errorMsg = "File type must be xml.">
		<cflocation addtoken="No" url="index.cfm?errorMsg=#ErrorMsg#">
	</cfif>
	<cfset ini_root="#txtRoot#" />
	<cfset ini_startPage="#txtStart#" />
	<cfset ini_levelMax="#txtLevels#" />
	<!--- use _sitemapold to test the old code --->
	<cfinvoke component="#componentType#" method="sitemap" returnvariable="qry_sitemap" root="#ini_root#" url="#ini_startPage#" depthMax="#ini_levelMax#">
	<cfinvoke component="#componentType#" method="indexIt" returnvariable="qry_sitemapIndex" root="#ini_root#" query="#qry_sitemap#">
	<cfinvoke component="#componentType#" method="googleSitemap" returnvariable="sitemap" root="#ini_root#" query="#qry_sitemap#">

<cfelse>
	<cfinvoke component="_sitemap" method="submitSitemap" url="#ini_sitemap#" returnvariable="statusMessage" checkboxes="#form#">
	<table align="center">
    	<tr>
    		<td style="font-weight:bold; color:white;">
				<cfloop from="1" to="#arrayLen(statusMessage)#" index="i">
					<cfif statusMessage[i] EQ "200">
						Sitemap #i# succesfully submitted<br/>
					<cfelse>
						Sitemap #i# encountered an error #statusMessage[i]#	<br/>
					</cfif>	
				</cfloop>
			</td>
    	</tr>
    </table>
	<cfexit>
</cfif>
	<form method="post">
		<table align="center">
		<cfif componentType EQ "_sitemap">
			<cffile action="write" file="#expandpath('sitemap.xml')#" output="#tostring(Sitemap[1])#">
			<tr>
				<td>
					<p>
						Sitemap has been created in
						<!--- inline if that checks if its greater than 60 seconds it counts it in minutes otherwise its in sesconds --->
						#iif((NumberFormat(((GetTickCount() - sitemap[2]) / 1000), ",.00") GT 60),DE(NumberFormat(((GetTickCount() - sitemap[2]) / 1000), ",.00") / 60),DE(NumberFormat(((GetTickCount() - sitemap[2]) / 1000), ",.00")))# 
						#iif((NumberFormat(((GetTickCount() - sitemap[2]) / 1000), ",.00") GT 60),DE('minutes'),DE('seconds'))# with #Sitemap[3]# total results 
					</p>			
					<p>
						Web site 
						was crawled in
						#iif((NumberFormat(((GetTickCount() - session.intStartTime) / 1000), ",.00") GT 60),DE(NumberFormat(((GetTickCount() - session.intStartTime) / 1000), ",.00") / 60),DE(NumberFormat(((GetTickCount() - session.intStartTime) / 1000), ",.00")))#
						#iif((NumberFormat(((GetTickCount() - session.intStartTime) / 1000), ",.00") GT 60),DE('minutes'),DE('seconds'))#
					</p>	
				</td>
			</tr>
		<cfelse>	
			<tr>
				<td>
					Created in #NumberFormat(((GetTickCount() - cf7Timer) / 1000), ",.00")# seconds
				</td>
			</tr>
		</cfif>
			<tr>
				<td>
					<h2>
						Step 2
					</h2>
				</td>
			</tr>
			<tr>
				<th>
					Now that the sitemap has been created, it is time to submit it to be indexed.
				</th>
			</tr>
			<tr>
				<td>
					<input type="Checkbox" name="chkAsk"/>Ask<br/>
					<input type="Checkbox" name="chkGoogle"/>Google<br/>
					<input type="Checkbox" name="chkYahoo"/>Yahoo<br/>
					<input type="Checkbox" name="chkMSN"/>MSN<br/>
					<input type="Checkbox" name="chkBlogsearch"/>BlogSearch.Google<br/>
					<input type="Checkbox" name="chkTechnorati"/>Technorati<br/>
				</td>
			</tr>
			<tr>
				<td>
					After this you will see the effect in 2-3 days. You will probably find more pages in the search engines then before. Note that you can’t force Googlebot to visit you more often - what you can do is to invite it to come.
				</td>
			</tr>
			<tr>
				<td>URL
					<input type="text" name="ini_sitemap" value="#txtRoot##txtStart#" size="60">
				</td>
			</tr>
			<tr>
				<td>
					<input type="submit" value="Finish"><input type="Hidden" name="doSubmit">
				</td>
			</tr>
		</table>
	</form>	
</cfoutput>