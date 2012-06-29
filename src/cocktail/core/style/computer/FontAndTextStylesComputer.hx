/*
	This file is part of Cocktail http://www.silexlabs.org/groups/labs/cocktail/
	This project is © 2010-2011 Silex Labs and is released under the GPL License:
	This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License (GPL) as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. 
	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
	To read the license please visit http://www.gnu.org/copyleft/gpl.html
*/
package cocktail.core.style.computer;

import cocktail.core.style.CoreStyle;
import cocktail.core.unit.UnitData;
import cocktail.core.style.StyleData;
import cocktail.core.unit.UnitManager;
import cocktail.core.font.FontData;
import haxe.Log;

/**
 * Compute the Font and Text related styles
 * of a HTMLElement, helped by the containing
 * HTMLElement dimensions and font metrics
 * 
 * @author Yannick DOMINGUEZ
 */
class FontAndTextStylesComputer 
{
	/**
	 * Class contructor. Private, as
	 * this class is meant to be accessed
	 * through its public static methods
	 */
	private function new() 
	{
		
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// PUBLIC STATIC METHODS
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * compute all the font and text styles of the HTMLElement
	 * @param	style
	 * @param	containingBlockData
	 * @param	containingBlockFontMetricsData
	 */
	public static function compute(style:CoreStyle, containingBlockData:ContainingBlockData, containingBlockFontMetricsData:FontMetricsData):Void
	{
		var computedStyle = style.computedStyle;

		//font size
		computedStyle.fontSize = getComputedFontSize(style, containingBlockFontMetricsData.fontSize, containingBlockFontMetricsData.xHeight);
		
		//line height
		computedStyle.lineHeight = getComputedLineHeight(style);
		
		//vertival align
		computedStyle.verticalAlign = getComputedVerticalAlign(style, containingBlockFontMetricsData);
		
		//letter spacing
		computedStyle.letterSpacing = getComputedLetterSpacing(style);
		
		//word spacing
		computedStyle.wordSpacing = getComputedWordSpacing(style);
		
		//text indent
		computedStyle.textIndent = getComputedTextIndent(style, containingBlockData);
		
		//text color
		computedStyle.color = getComputedColor(style);
		
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// PRIVATE STATIC METHODS
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Compute the text indent to apply to the first line of an inline formatting context
	 */
	private static function getComputedTextIndent(style:CoreStyle, containingBlockData:ContainingBlockData):Float
	{
		var textIndent:Float;
		
		switch(style.textIndent)
		{
			case length(value):
				textIndent = UnitManager.getPixelFromLength(value, style.fontMetrics.fontSize, style.fontMetrics.xHeight);
				
			case percentage(value):
				textIndent = UnitManager.getPixelFromPercent(value, containingBlockData.width);
		}
		
		return textIndent;
	}
	
	/**
	 * Compute the vertical offset to apply to a HTMLElement in an inline
	 * formatting context.
	 */
	private static function getComputedVerticalAlign(style:CoreStyle, containingBlockFontMetricsData:FontMetricsData):Float
	{
		var verticalAlign:Float;
		
		switch(style.verticalAlign)
		{
			case baseline:
				verticalAlign = 0;
				
			case middle:
				verticalAlign = 0;
				
			case sub:
				verticalAlign = containingBlockFontMetricsData.subscriptOffset;
				
			case cssSuper:
				verticalAlign = containingBlockFontMetricsData.superscriptOffset;
				
			case textTop:
				verticalAlign = 0;
				
			case textBottom:
				verticalAlign = 0;
				
			case percent(value):
				verticalAlign = UnitManager.getPixelFromPercent(value, style.computedStyle.lineHeight);
				
			case length(value):
				verticalAlign = UnitManager.getPixelFromLength(value, style.fontMetrics.fontSize, style.fontMetrics.xHeight);
				
			case top:
				verticalAlign = 0;
			case bottom:	
				verticalAlign = 0;
		}
		
		return verticalAlign;
	}
	
	/**
	 * Computed the color of a text of the HTMLElement
	 */
	private static function getComputedColor(style:CoreStyle):ColorData
	{
		return UnitManager.getColorDataFromCSSColor(style.color);
	}
	
	/**
	 * Compute the space to add between each word in a text in
	 * addition of the regular font space
	 */
	private static function getComputedWordSpacing(style:CoreStyle):Float
	{
		var wordSpacing:Float;
		
		switch (style.wordSpacing)
		{
			case normal:
				wordSpacing = 0;
				
			case length(unit):
				wordSpacing = UnitManager.getPixelFromLength(unit, style.computedStyle.fontSize, style.fontMetrics.xHeight);
		}
		
		return wordSpacing;
	}
	
	/**
	 * Compute the line height of a HTMLElement in an inline
	 * formatting context
	 */
	private static function getComputedLineHeight(style:CoreStyle):Float
	{
		var lineHeight:Float;
		
		switch (style.lineHeight)
		{
			case length(unit):
				lineHeight = UnitManager.getPixelFromLength(unit, style.computedStyle.fontSize, style.fontMetrics.xHeight);
				
			case normal:
				lineHeight = style.computedStyle.fontSize * 1.2;
				
			case percentage(value):
				lineHeight = UnitManager.getPixelFromPercent(value, style.computedStyle.fontSize);
				
			case number(value):
				lineHeight = style.computedStyle.fontSize * value;
		}
		
		return lineHeight;
	}
	
	/**
	 * Compute the space to apply between each
	 * letter in a text, in addition to the regular
	 * font letter spacing
	 */
	private static function getComputedLetterSpacing(style:CoreStyle):Float
	{
		var letterSpacing:Float;
		
		switch (style.letterSpacing)
		{
			case normal:
				letterSpacing = 0.0;
				
			case length(unit):
				letterSpacing = UnitManager.getPixelFromLength(unit, style.fontMetrics.fontSize, style.fontMetrics.xHeight);
		}
		
		return letterSpacing;
	}
	
	/**
	 * Compute the font size of the text of a HTMLElement
	 */
	private static function getComputedFontSize(style:CoreStyle, parentFontSize:Float, parentXHeight:Float):Float
	{
		var fontSize:Float;
		
		switch (style.fontSize)
		{
			case length(unit):
				fontSize = UnitManager.getPixelFromLength(unit, parentFontSize, parentXHeight);
				
			case percentage(percent):
				fontSize = UnitManager.getPixelFromPercent(percent, parentFontSize);
				
			case absoluteSize(value):
				fontSize = UnitManager.getFontSizeFromAbsoluteSizeValue(value);
				
			case relativeSize(value):
				fontSize = UnitManager.getFontSizeFromRelativeSizeValue(value, parentFontSize);
				
		}
		
		return fontSize;
	}
}