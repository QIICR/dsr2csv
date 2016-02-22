<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:docbook="http://docbook.org/ns/docbook"
    xmlns="http://docbook.org/ns/docbook"
    version="1.0">
    
    <xsl:output method="text" encoding="utf-8"/>
	
    <xsl:variable name="quote">"</xsl:variable>
    <xsl:variable name="comma">,</xsl:variable>
    
    <!-- NB. Must be no indentation before closing marker for <xsl:text/>, otherwise tab etc. will be copied to the output - be careful when reindenting entire template to look pretty ! -->
    <xsl:variable name="newline">
        <xsl:text>
</xsl:text>
    </xsl:variable>
    
    <xsl:template match="report">

		<!-- probably want to improve text used for headings (use spaces, etc.) at some point :( -->
		<!-- write heading row - obviously need to keep this in sync with each row written below -->
		<xsl:value-of select="$quote"/><xsl:text>patientID</xsl:text><xsl:value-of select="$quote"/>
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$quote"/><xsl:text>personObserverName</xsl:text><xsl:value-of select="$quote"/>
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$quote"/><xsl:text>timepoint</xsl:text><xsl:value-of select="$quote"/>
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$quote"/><xsl:text>activitySession</xsl:text><xsl:value-of select="$quote"/>
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$quote"/><xsl:text>trackingID</xsl:text><xsl:value-of select="$quote"/>
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$quote"/><xsl:text>finding</xsl:text><xsl:value-of select="$quote"/>
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$quote"/><xsl:text>findingSite</xsl:text><xsl:value-of select="$quote"/>
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$quote"/><xsl:text>laterality</xsl:text><xsl:value-of select="$quote"/>
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$quote"/><xsl:text>measurementConcept</xsl:text><xsl:value-of select="$quote"/>
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$quote"/><xsl:text>measurementMethod</xsl:text><xsl:value-of select="$quote"/>
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$quote"/><xsl:text>derivation</xsl:text><xsl:value-of select="$quote"/>
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$quote"/><xsl:text>measurementValue</xsl:text><xsl:value-of select="$quote"/>
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$quote"/><xsl:text>measurementUnits</xsl:text><xsl:value-of select="$quote"/>
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$quote"/><xsl:text>referencedSegmentSOPInstanceUID</xsl:text><xsl:value-of select="$quote"/>
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$quote"/><xsl:text>referencedSegmentNumbers</xsl:text><xsl:value-of select="$quote"/>
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$quote"/><xsl:text>sourceImageSeriesInstanceUID</xsl:text><xsl:value-of select="$quote"/>
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$quote"/><xsl:text>rwvmSOPInstanceUID</xsl:text><xsl:value-of select="$quote"/>
		<xsl:value-of select="$comma"/>
		<xsl:value-of select="$newline"/>

		<!-- apply normalize-space() to all extracted fields just in case, since will really screw up CSV output if any new lines get propagated; has not been necessary with Iowa data, but does not harm -->
        <xsl:variable name="patientID" select="normalize-space(patient/id)"/>

		<!-- the use of normalize-space() here is important, to make sure new lines, etc., between text value of elements of <value/> are not copied, rather than using <value/>/<last/> (even though only <last/> component is populated in Iowa data) -->
        <xsl:variable name="personObserverName" select="normalize-space(document/content/container[concept/value = '126000' and concept/scheme/designator = 'DCM']/pname[concept/value = '121008' and concept/scheme/designator = 'DCM']/value)"/>	<!-- Imaging Measurement Report/Person Observer Name -->
        
        <xsl:for-each select="document/content/container[concept/value = '126000' and concept/scheme/designator = 'DCM']/container[concept/value = '126010' and concept/scheme/designator = 'DCM']/container[concept/value = '125007' and concept/scheme/designator = 'DCM']">	<!-- Imaging Measurement Report/Imaging Measurements/Measurement Group -->
            
			<xsl:variable name="activitySession" select="normalize-space(text[concept/value = 'C67447' and concept/scheme/designator = 'NCIt']/value)"/>
			<xsl:variable name="trackingID" select="normalize-space(text[concept/value = '112039' and concept/scheme/designator = 'DCM']/value)"/>
			<xsl:variable name="finding" select="normalize-space(code[concept/value = '121071' and concept/scheme/designator = 'DCM']/meaning)"/>
			<xsl:variable name="timepoint" select="normalize-space(text[concept/value = 'C2348792' and concept/scheme/designator = 'UMLS']/value)"/>
			<xsl:variable name="referencedSegmentSOPInstanceUID" select="normalize-space(image[concept/value = '121191' and concept/scheme/designator = 'DCM']/value/instance/@uid)"/>
			<xsl:variable name="referencedSegmentNumbers" select="normalize-space(image[concept/value = '121191' and concept/scheme/designator = 'DCM']/value/segments)"/>	<!-- NB. may be multiple comma-separated; OK because will be quoted later; also requires recent build of dcmtk dsr2xml -->
			<xsl:variable name="sourceImageSeriesInstanceUID" select="normalize-space(uidref[concept/value = '121232' and concept/scheme/designator = 'DCM']/value)"/>
			<xsl:variable name="rwvmSOPInstanceUID" select="normalize-space(composite[concept/value = '126100' and concept/scheme/designator = 'DCM']/value/instance/@uid)"/>
			<xsl:variable name="commonMeasurementMethod" select="normalize-space(code[concept/value = 'G-C036' and concept/scheme/designator = 'SRT']/meaning)"/>
			<xsl:variable name="commonFindingSite" select="normalize-space(code[concept/value = 'G-C0E3' and concept/scheme/designator = 'SRT']/meaning)"/>
			<!-- not tested yet since not used in Iowa data :( -->
			<xsl:variable name="commonLaterality" select="normalize-space(code[concept/value = 'G-C0E3' and concept/scheme/designator = 'SRT']/code[concept/value = 'G-C171' and concept/scheme/designator = 'SRT']/meaning)"/>
			<!-- ? need to do (G-A1F8, SRT,"Topographical modifier) child of finding site too ? not used in Iowa data :( -->
			
			<xsl:for-each select="num">
				<xsl:variable name="measurementConcept" select="normalize-space(concept/meaning)"/>
				<xsl:variable name="measurementValue" select="normalize-space(value)"/>
				<xsl:variable name="measurementUnits" select="normalize-space(unit/meaning)"/>		<!-- do we want to use (shorter) code value instead of meaning ? :( -->

				<xsl:variable name="derivation" select="normalize-space(code[concept/value = '121401' and concept/scheme/designator = 'DCM']/meaning)"/>

				<xsl:variable name="localMeasurementMethod" select="normalize-space(code[concept/value = 'G-C036' and concept/scheme/designator = 'SRT']/meaning)"/>
				<xsl:variable name="measurementMethod">
					<xsl:choose>
						<xsl:when test="string-length($localMeasurementMethod) &gt; 0">
							<xsl:value-of select="$localMeasurementMethod"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$commonMeasurementMethod"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="localFindingSite" select="normalize-space(code[concept/value = 'G-C0E3' and concept/scheme/designator = 'SRT']/meaning)"/>
				<xsl:variable name="findingSite">
					<xsl:choose>
						<xsl:when test="string-length($localFindingSite) &gt; 0">
							<xsl:value-of select="$localFindingSite"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$commonFindingSite"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- not tested yet since not used in Iowa data :( -->
				<xsl:variable name="localLaterality" select="normalize-space(code[concept/value = 'G-C0E3' and concept/scheme/designator = 'SRT']/code[concept/value = 'G-C171' and concept/scheme/designator = 'SRT']/meaning)"/>
				<xsl:variable name="laterality">
					<xsl:choose>
						<xsl:when test="string-length($localLaterality) &gt; 0">
							<xsl:value-of select="$localLaterality"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$commonLaterality"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- write CSV row - obviously need to keep this in sync with heading row written above -->
				<xsl:value-of select="$quote"/><xsl:value-of select="$patientID"/><xsl:value-of select="$quote"/>
				<xsl:value-of select="$comma"/>
				<xsl:value-of select="$quote"/><xsl:value-of select="$personObserverName"/><xsl:value-of select="$quote"/>
				<xsl:value-of select="$comma"/>
				<xsl:value-of select="$quote"/><xsl:value-of select="$timepoint"/><xsl:value-of select="$quote"/>
				<xsl:value-of select="$comma"/>
				<xsl:value-of select="$quote"/><xsl:value-of select="$activitySession"/><xsl:value-of select="$quote"/>
				<xsl:value-of select="$comma"/>
				<xsl:value-of select="$quote"/><xsl:value-of select="$trackingID"/><xsl:value-of select="$quote"/>
				<xsl:value-of select="$comma"/>
				<xsl:value-of select="$quote"/><xsl:value-of select="$finding"/><xsl:value-of select="$quote"/>
				<xsl:value-of select="$comma"/>
				<xsl:value-of select="$quote"/><xsl:value-of select="$findingSite"/><xsl:value-of select="$quote"/>
				<xsl:value-of select="$comma"/>
				<xsl:value-of select="$quote"/><xsl:value-of select="$laterality"/><xsl:value-of select="$quote"/>
				<xsl:value-of select="$comma"/>
				<xsl:value-of select="$quote"/><xsl:value-of select="$measurementConcept"/><xsl:value-of select="$quote"/>
				<xsl:value-of select="$comma"/>
				<xsl:value-of select="$quote"/><xsl:value-of select="$measurementMethod"/><xsl:value-of select="$quote"/>
				<xsl:value-of select="$comma"/>
				<xsl:value-of select="$quote"/><xsl:value-of select="$derivation"/><xsl:value-of select="$quote"/>
				<xsl:value-of select="$comma"/>
				<xsl:value-of select="$quote"/><xsl:value-of select="$measurementValue"/><xsl:value-of select="$quote"/>
				<xsl:value-of select="$comma"/>
				<xsl:value-of select="$quote"/><xsl:value-of select="$measurementUnits"/><xsl:value-of select="$quote"/>
				<xsl:value-of select="$comma"/>
				<xsl:value-of select="$quote"/><xsl:value-of select="$referencedSegmentSOPInstanceUID"/><xsl:value-of select="$quote"/>
				<xsl:value-of select="$comma"/>
				<xsl:value-of select="$quote"/><xsl:value-of select="$referencedSegmentNumbers"/><xsl:value-of select="$quote"/>
				<xsl:value-of select="$comma"/>
				<xsl:value-of select="$quote"/><xsl:value-of select="$sourceImageSeriesInstanceUID"/><xsl:value-of select="$quote"/>
				<xsl:value-of select="$comma"/>
				<xsl:value-of select="$quote"/><xsl:value-of select="$rwvmSOPInstanceUID"/><xsl:value-of select="$quote"/>
				<xsl:value-of select="$comma"/>
				<xsl:value-of select="$newline"/>

			</xsl:for-each>
        </xsl:for-each>
        
    </xsl:template>
    
    <!-- overrides default rule and deletes rather than copies averything else to output -->
    <xsl:template match="@*|node()">
        <xsl:apply-templates/>
    </xsl:template>
    
</xsl:stylesheet>
