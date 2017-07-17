/**
 * リソースを読み込むモジュール。
 *
 * Date: 2017/7/18
 * Authors: masaniwa
 */

module desktopdial.loading;

import std.conv : ConvOverflowException;
import std.file : FileException, readText;
import std.utf : UTFException;

import jsonserialized.deserialization : deserializeFromJSONValue;
import stdx.data.json : toJSONValue;
import stdx.data.json.foundation : JSONException;

import desktopdial.dial : DialDefinition;
import desktopdial.exception : DefinitionException;

/**
 * jsonファイルから時計盤の定義を読み込む。
 *
 * Params:
 *     path = jsonファイルのパス。
 *
 * Returns: 読み込んだ時計盤の定義。
 *
 * Throws:
 *     DefinitionException jsonファイルの読み込みに失敗した場合。
 */
DialDefinition loadDialDefinition(in string path) @safe
in
{
    assert(path);
}
body
{
    try
    {
        return path.readText.toJSONValue.deserializeFromJSONValue!DialDefinition;
    }
    catch (FileException e)
    {
        throw new DefinitionException("The file wasn't found.", e);
    }
    catch (JSONException e)
    {
        throw new DefinitionException("The json was wrong format.", e);
    }
    catch (UTFException e)
    {
        throw new DefinitionException("The file must be unicode encoding.", e);
    }
    catch (ConvOverflowException e)
    {
        throw new DefinitionException("The value was too larger or smaller.", e);
    }
}
