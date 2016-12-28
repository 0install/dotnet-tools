<?xml version="1.0" encoding="UTF-8"?>
<!--
Author: Tim Cuthbertson
Modified by Thomas Leonard and Bastian Eicher.
License: Creative Commons Attribution-ShareAlike 2.5 license
http://creativecommons.org/licenses/by-sa/2.5/
-->
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:zi="http://zero-install.sourceforge.net/2004/injector/interface"
		version="1.0">
	<xsl:output method="xml" encoding="utf-8" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"/>
	<xsl:template match="/zi:interface">
		<html>
			<head>
				<title>
					<xsl:value-of select="zi:name"/>
				</title>
				<link rel="stylesheet" type="text/css" href='feed.css'/>
			</head>
			<body>
				<div class="site">
					<div class="main">
						<div class="content">
							<div class="post inner">

								<xsl:variable name="icon-href" select="(zi:icon[@type='image/png'][1])/@href"/>
								<xsl:if test="$icon-href != ''">
									<img src="{$icon-href}" class="alpha icon" />
								</xsl:if>

								<h1><xsl:value-of select="zi:name"/></h1>
								<h2><xsl:value-of select='zi:summary'/></h2>

								<div class="what-is-this">
									<xsl:if test="//zi:implementation[@main] | //zi:group[@main] | //zi:command[@name='run'] | //zi:package-implementation[@main]">								
										<form action="https://0install.de/bootstrap/" method="get" style="float: left; margin-right: 4px;">
											<input type="hidden" name="name" value="{zi:name}"/>
											<input type="hidden" name="uri" value="{/zi:interface/@uri}"/>
											<input type="hidden" name="mode" value="run"/>
											<input type="submit" value="Run {zi:name}"/>
										</form>
										<form action="https://0install.de/bootstrap/" method="get" style="clear: right;">
											<input type="hidden" name="name" value="{zi:name}"/>
											<input type="hidden" name="uri" value="{/zi:interface/@uri}"/>
											<input type="hidden" name="mode" value="integrate"/>
											<input type="submit" value="Integrate {zi:name}"/>
										</form>
									</xsl:if>
									This page is a Zero Install feed.<br/>
									<a href="#what-is-this">Learn more...</a>
								</div>

								<dl>
									<xsl:if test="zi:replaced-by">
										<dt>This interface is obsolete!</dt>
										<dd>
											<p class="yourinfo">
												Please use this one instead:
											</p>
											<ul>
												<xsl:for-each select="zi:replaced-by">
													<li>
														<a>
															<xsl:attribute name="href">
																<xsl:value-of select="@interface"/>
															</xsl:attribute>
															<xsl:value-of select="@interface"/>
														</a>
													</li>
												</xsl:for-each>
											</ul>
										</dd>
									</xsl:if>

									<xsl:if test="zi:feed-for">
										<dt>Interface</dt>
										<dd>
											<p class="yourinfo">
												In most cases, you should use the interface URI instead of this feed's URI.
											</p>
											<ul>
												<xsl:for-each select="zi:feed-for">
													<li>
														<a>
															<xsl:attribute name="href">
																<xsl:value-of select="@interface"/>
															</xsl:attribute>
															<xsl:value-of select="@interface"/>
														</a>
													</li>
												</xsl:for-each>
											</ul>
										</dd>
									</xsl:if>

									<xsl:apply-templates mode="dl" select="*|@*"/>

									<dt>Required libraries</dt>
									<dd>
										<xsl:choose>
											<xsl:when test="//zi:requires|//zi:runner">
												<p class="yourinfo">(Zero Install will automatically download any required libraries for you)</p>
												<ul>
													<xsl:for-each select="//zi:requires|//zi:runner">
														<xsl:variable name="interface" select="@interface"/>
														<xsl:if test="not(preceding::zi:requires[@interface = $interface]) and not(preceding::zi:runner[@interface = $interface])">
															<li>
																<a>
																	<xsl:attribute name="href">
																		<xsl:value-of select="$interface"/>
																	</xsl:attribute>
																	<xsl:value-of select="$interface"/>
																</a>
															</li>
														</xsl:if>
													</xsl:for-each>
												</ul>
											</xsl:when>
											<xsl:otherwise>
												<p>This feed does not list any additional requirements.</p>
											</xsl:otherwise>
										</xsl:choose>
									</dd>

									<xsl:if test="zi:feed">
										<dt>Other feeds for this interface:</dt>
										<dd>
											<p class="yourinfo">
												(Zero Install will also check these feeds when deciding which version to use)
											</p>
											<ul>
												<xsl:for-each select="zi:feed">
													<li>
														<a>
															<xsl:attribute name="href">
																<xsl:value-of select="@src"/>
															</xsl:attribute>
															<xsl:value-of select="@src"/>
														</a>
													</li>
												</xsl:for-each>
											</ul>
										</dd>
									</xsl:if>

									<dt>Available versions</dt>
									<dd>
										<xsl:choose>
											<xsl:when test="//zi:implementation|//zi:package-implementation">
												<p class="yourinfo">
													(Zero Install will automatically download one of these versions for you)
												</p>
												<xsl:if test='//zi:implementation'>
													<table cellpadding="0" cellspacing="0">
														<tr>
															<th>Version</th>
															<th>Released</th>
															<th>Stability</th>
															<th>Platform</th>
															<th>Download</th>
														</tr>
														<xsl:for-each select="//zi:implementation">
															<tr>
																<td>
																	<xsl:value-of select="(ancestor-or-self::*[@version])[last()]/@version"/>
																	<xsl:if test="(ancestor-or-self::*[@version])[last()]/@version-modifier">
																		<xsl:value-of select="(ancestor-or-self::*[@version])[last()]/@version-modifier"/>
																	</xsl:if>
																</td>
																<td>
																	<xsl:value-of select="(ancestor-or-self::*[@released])[last()]/@released"/>
																</td>
																<td>
																	<xsl:value-of select="(ancestor-or-self::*[@stability])[last()]/@stability"/>
																</td>
																<td>
																	<xsl:variable name="arch" select="(ancestor-or-self::*[@arch])[last()]/@arch"/>
																	<xsl:choose>
																		<xsl:when test="$arch = &quot;*-src&quot;">Source code</xsl:when>
																		<xsl:when test="not($arch)">Any</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="$arch"/>
																		</xsl:otherwise>
																	</xsl:choose>
																</td>
																<td>
																	<xsl:for-each select=".//zi:archive">
																		<a href="{@href}">Download</a> (<xsl:value-of select="@size"/> bytes)
																	</xsl:for-each>
																</td>
															</tr>
														</xsl:for-each>
													</table>
												</xsl:if>

												<xsl:if test='//zi:package-implementation'>
													<p>Non-Zero Install packages provided by distributions can provide this interface:</p>
													<table cellpadding="0" cellspacing="0">
														<tr>
															<th>Distribution</th>
															<th>Package name</th>
														</tr>
														<xsl:for-each select='//zi:package-implementation'>
															<tr>
																<td>
																	<xsl:value-of select='(ancestor-or-self::*[@distributions])[last()]/@distributions'/>
																</td>
																<td>
																	<xsl:value-of select='(ancestor-or-self::*[@package])[last()]/@package'/>
																</td>
															</tr>
														</xsl:for-each>
													</table>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<p>No versions are available for downlad.</p>
											</xsl:otherwise>
										</xsl:choose>
									</dd>

								</dl>
							</div>
						</div>
						<div class="clear"/>
					</div>
					<div class="chrome">
						<div class="inner">
							<div class="explanation">
								<a name="what-is-this"></a>
								<h3>What is this page, and how do I use it?</h3>
								<xsl:choose>
									<xsl:when test="//zi:implementation[@main] | //zi:group[@main] | //zi:command[@name='run'] | //zi:package-implementation[@main]">
										<p>
											This is a Zero Install feed. If you have <a href="http://0install.net/">Zero Install</a> on your system you
											can use it to run <xsl:value-of select="zi:name"/> from the command-line:
										</p>
										<pre>0install run <xsl:value-of select="/zi:interface/@uri"/></pre>
										<p>
											This will download a suitable implementation of <xsl:value-of select="zi:name"/> (along with any dependencies)
											and then run it without any side effects for other software on your system.
										</p>
									</xsl:when>
									<xsl:otherwise>
										<p>
											This is a Zero Install feed for <xsl:value-of select="zi:name"/>.
											<xsl:value-of select="zi:name"/> is a library and cannot be run as an application directly.
										</p>
										<p>
											For more information about using Zero Install packages, see the <a href="http://0install.net/dev.html">Zero Install developer's guide</a>.
										</p>
									</xsl:otherwise>
								</xsl:choose>
							</div>
						</div>
					</div>
				</div>
				<!--
				<div class="clear"/>
				<div class="inner footer">
				</div>
				-->
			</body>
		</html>
	</xsl:template>




	<xsl:template mode="dl" match="/zi:interface/@uri">
		<dt>Full URL</dt>
		<dd>
			<p>
				<a href="{.}">
					<xsl:value-of select="."/>
				</a>
			</p>
		</dd>
	</xsl:template>
	<xsl:template mode="dl" match="zi:homepage">
		<dt>Homepage</dt>
		<dd>
			<p>
				<a href="{.}">
					<xsl:value-of select="."/>
				</a>
			</p>
		</dd>
	</xsl:template>

	<xsl:template mode="dl" match="zi:description">
		<dt>Description</dt>
		<dd class="description">
			<xsl:call-template name='description'>
				<xsl:with-param name='text'><xsl:value-of select='.'/></xsl:with-param>
			</xsl:call-template>
		</dd>
	</xsl:template>

	<xsl:template name='description'>
		<xsl:param name="text"/>
		<xsl:if test='normalize-space($text)'>
			<xsl:variable name='first' select='substring-before($text, "&#xa;&#xa;")'/>
			<xsl:choose>
				<xsl:when test='normalize-space($first)'>
					<p><xsl:value-of select='$first'/></p>
					<xsl:call-template name='description'>
						<xsl:with-param name='text'><xsl:value-of select='substring-after($text, "&#xa;&#xa;")'/></xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<p><xsl:value-of select='$text'/></p>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<!-- <xsl:template mode="dl" match="zi:icon"> -->
	<!-- 	<dt>Icon</dt> -->
	<!-- 	<dd> -->
	<!-- 		<p> -->
	<!-- 			<img src="{@href}" class="alpha"/> -->
	<!-- 		</p> -->
	<!-- 	</dd> -->
	<!-- </xsl:template> -->
	<xsl:template mode="dl" match="*|@*"/>
	<xsl:template match="zi:group">
		<dl class="group">
			<xsl:apply-templates mode="attribs" select="@stability|@version|@id|@arch|@released"/>
			<xsl:apply-templates select="zi:group|zi:requires|zi:runner|zi:implementation"/>
		</dl>
	</xsl:template>
	<xsl:template match="zi:requires | zi:runner">
		<dt>Requires</dt>
		<dd>
			<a href="{@interface}">
				<xsl:value-of select="@interface"/>
			</a>
		</dd>
	</xsl:template>
	<xsl:template match="zi:implementation">
		<dl class="impl">
			<xsl:apply-templates mode="attribs" select="@stability|@version|@id|@arch|@released"/>
			<xsl:apply-templates/>
		</dl>
	</xsl:template>
	<xsl:template mode="attribs" match="@*">
		<dt>
			<xsl:value-of select="name(.)"/>
		</dt>
		<dd>
			<xsl:value-of select="."/>
		</dd>
	</xsl:template>
	<xsl:template match="zi:archive">
		<dt>Download</dt>
		<dd>
			<a href="{@href}">
				<xsl:value-of select="@href"/>
			</a>
			(<xsl:value-of select="@size"/> bytes)
		</dd>
	</xsl:template>
</xsl:stylesheet>
